library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
    port(
        clk           : in std_logic;
        rst           : in std_logic;
        instr_in      : in unsigned(14 downto 0); -- Vem do novo Registrador de Instruções (RI)
        
        -- Saídas de Controle
        pc_out        : out unsigned(6 downto 0); -- Para a ROM
        estado_out    : out unsigned(1 downto 0); -- Para debug
        wr_en_pc      : out std_logic;            -- Write enable do PC
        wr_en_ri      : out std_logic;            -- Write enable do RI
        
        -- Sinais de controle para o Datapath (top_level_banco_ula)
        wr_en_banco   : out std_logic;
        wr_en_acum    : out std_logic;
        sel_reg_rd    : out unsigned(2 downto 0);
        sel_reg_wr    : out unsigned(2 downto 0);
        sel_ula       : out unsigned(1 downto 0);
        sel_mux_acum  : out std_logic;
        sel_mux_banco : out unsigned(1 downto 0);
        sel_mux_ula_y : out std_logic;
        constante_out : out unsigned(15 downto 0) -- Constante de 16 bits para o datapath
    );
end entity;

architecture a_unidade_controle of unidade_controle is
    -- Componente PC (do Lab 4)
    component pc is
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;
    
    -- Componente Máquina de Estados (Modificado)
    component maq_estados is
        port(
            clk    : in std_logic;
            rst    : in std_logic;
            estado : out unsigned(1 downto 0)
        );
    end component;
    
    -- Sinais internos da UC
    signal estado_s   : unsigned(1 downto 0);
    signal pc_atual   : unsigned(6 downto 0);
    signal pc_prox    : unsigned(6 downto 0);
    
    -- Sinais decodificados da instrução
    signal opcode      : unsigned(3 downto 0);
    signal reg_dest_s  : unsigned(2 downto 0);
    signal reg_font_s  : unsigned(2 downto 0);
    signal const_8_s   : unsigned(7 downto 0);
    signal jump_addr_s : unsigned(6 downto 0);
    
    -- Sinais de habilitação das instruções (decodificados do opcode)
    signal nop_en, jump_en, li_en, mov_ar_en, mov_ra_en, add_ar_en, addi_ac_en, sub_ar_en : std_logic; -- REFATORADO

begin
    -- 1. Instanciação dos componentes internos da UC
    pc_inst: pc port map(
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en_pc, -- Controlado pela lógica do sorteio
        data_in  => pc_prox,
        data_out => pc_atual
    );
    
    maq_inst: maq_estados port map(
        clk    => clk,
        rst    => rst,
        estado => estado_s
    );

    -- 2. Decodificação da Instrução (lógica combinacional)
    -- Extrai os campos da instrução vinda do RI
    opcode      <= instr_in(14 downto 11);
    reg_dest_s  <= instr_in(10 downto 8);
    reg_font_s  <= instr_in(7 downto 5);
    const_8_s   <= instr_in(7 downto 0);
    jump_addr_s <= instr_in(10 downto 4); -- Corrigido

    -- Decodifica o opcode
    nop_en     <= '1' when opcode = "0000" else '0';
    li_en      <= '1' when opcode = "0001" else '0'; -- LI Rdest, Const8
    mov_ar_en  <= '1' when opcode = "0010" else '0'; -- MOV Acum, Rfont
    mov_ra_en  <= '1' when opcode = "0011" else '0'; -- MOV Rdest, Acum
    add_ar_en  <= '1' when opcode = "0100" else '0'; -- ADD Acum, Rfont
    addi_ac_en <= '1' when opcode = "0101" else '0'; -- REFATORADO: ADDI Acum, Const8
    sub_ar_en  <= '1' when opcode = "0110" else '0'; -- REFATORADO: SUB Acum, Rfont
    jump_en    <= '1' when opcode = "1111" else '0'; -- JMP Addr7

    -- 3. Geração dos Sinais de Controle (baseado no estado e Sorteio)
    
    -- Lógica do PC (Conforme Sorteio)
    pc_prox <= jump_addr_s when (jump_en = '1' and estado_s = "10") else
               (pc_atual + 1);
               
    wr_en_pc <= '1' when estado_s = "00" else
                '1' when (jump_en = '1' and estado_s = "10") else
                '0';
    
    -- Lógica do RI (Conforme Sorteio)
    wr_en_ri <= '1' when estado_s = "01" else '0';

    -- Saídas de Debug
    pc_out     <= pc_atual;
    estado_out <= estado_s;

    -- 4. Geração dos Sinais do Datapath (Ativos apenas no Estado 2, "10" - Execução)
    
    -- Write Enables (com proteção explícita do NOP)
    wr_en_banco <= '1' when (estado_s = "10" and (li_en = '1' or mov_ra_en = '1') and nop_en = '0') else '0';
    wr_en_acum  <= '1' when (estado_s = "10" and (mov_ar_en = '1' or add_ar_en = '1' or addi_ac_en = '1' or sub_ar_en = '1') and nop_en = '0') else '0'; -- REFATORADO

    -- Seleção de Registradores
    sel_reg_wr <= reg_dest_s when (estado_s = "10" and (li_en = '1' or mov_ra_en = '1')) else "000";
    sel_reg_rd <= reg_font_s when (estado_s = "10" and (mov_ar_en = '1' or add_ar_en = '1' or sub_ar_en = '1')) else "000"; -- REFATORADO

    -- Seleção dos MUXes
    -- MUX do Banco (Entrada do Banco)
    sel_mux_banco <= "01" when (estado_s = "10" and li_en = '1') else      -- "01" = Constante
                     "00" when (estado_s = "10" and mov_ra_en = '1') else -- "00" = Acumulador
                     "00"; -- Default

    -- MUX do Acumulador (Entrada do Acumulador)
    sel_mux_acum <= '1' when (estado_s = "10" and mov_ar_en = '1') else -- '1' = Banco
                    '0'; -- Default ('0' = Saída da ULA)

    -- MUX da ULA (Entrada Y da ULA)
    sel_mux_ula_y <= '1' when (estado_s = "10" and addi_ac_en = '1') else -- REFATORADO: '1' = Constante (ADDI)
                     '0'; -- Default ('0' = Banco)

    -- Seleção da Operação da ULA
    sel_ula <= "00" when (estado_s = "10" and (add_ar_en = '1' or addi_ac_en = '1')) else -- REFATORADO: "00" = ADD / ADDI
               "01" when (estado_s = "10" and sub_ar_en = '1') else -- REFATORADO: "01" = SUB
               "00"; -- Default

    -- Constante: Estende 8 bits da instrução para 16 bits (zero-extend)
    constante_out <= "00000000" & const_8_s;

end architecture;
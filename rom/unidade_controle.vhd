library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
    port(
        clk           : in std_logic;
        rst           : in std_logic;
        instr_in      : in unsigned(14 downto 0);
        
        flag_z_in     : in std_logic;
        flag_c_in     : in std_logic;
        flag_v_in     : in std_logic;
        flag_n_in     : in std_logic;
        
        pc_out        : out unsigned(6 downto 0);
        estado_out    : out unsigned(1 downto 0);
        wr_en_pc      : out std_logic;
        wr_en_ri      : out std_logic;
        
        wr_en_banco   : out std_logic;
        wr_en_acum    : out std_logic;
        wr_en_flags   : out std_logic;
        sel_reg_rd    : out unsigned(2 downto 0);
        sel_reg_wr    : out unsigned(2 downto 0);
        sel_ula       : out unsigned(1 downto 0);
        sel_mux_acum  : out unsigned(1 downto 0);
        sel_mux_banco : out unsigned(1 downto 0);
        sel_mux_ula_y : out std_logic;
        wr_en_ram     : out std_logic;
        constante_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_unidade_controle of unidade_controle is
    component pc is
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;
    
    component maq_estados is
        port(
            clk    : in std_logic;
            rst    : in std_logic;
            estado : out unsigned(1 downto 0)
        );
    end component;
    
    signal estado_s   : unsigned(1 downto 0);
    signal pc_atual   : unsigned(6 downto 0);
    signal pc_prox    : unsigned(6 downto 0);
    
    signal opcode      : unsigned(3 downto 0);
    signal reg_dest_s  : unsigned(2 downto 0);
    signal reg_font_s  : unsigned(2 downto 0);
    signal const_8_s   : unsigned(7 downto 0);
    signal jump_addr_s : unsigned(6 downto 0);

    signal nop_en, jump_en, li_en, mov_ar_en, mov_ra_en, add_ar_en, addi_ac_en, sub_ar_en : std_logic;
    signal cmpr_en, ble_en, bvs_en : std_logic;
    signal lw_en, sw_en : std_logic;
    
    -- sinais para branch relativo
    signal offset_s             : signed(7 downto 0);
    signal pc_relativo          : unsigned(6 downto 0);
    signal branch_condition_met : std_logic;

begin
    pc_inst: pc port map(
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en_pc,
        data_in  => pc_prox,
        data_out => pc_atual
    );
    
    maq_inst: maq_estados port map(
        clk    => clk,
        rst    => rst,
        estado => estado_s
    );

    opcode      <= instr_in(14 downto 11);
    reg_dest_s  <= instr_in(10 downto 8);
    reg_font_s  <= instr_in(7 downto 5);
    const_8_s   <= instr_in(7 downto 0);
    jump_addr_s <= instr_in(10 downto 4);

    -- decodifica o opcode
    nop_en     <= '1' when opcode = "0000" else '0';
    li_en      <= '1' when opcode = "0001" else '0';
    mov_ar_en  <= '1' when opcode = "0010" else '0';
    mov_ra_en  <= '1' when opcode = "0011" else '0';
    add_ar_en  <= '1' when opcode = "0100" else '0';
    addi_ac_en <= '1' when opcode = "0101" else '0';
    sub_ar_en  <= '1' when opcode = "0110" else '0';

    cmpr_en    <= '1' when opcode = "1000" else '0';
    ble_en     <= '1' when opcode = "1001" else '0';
    bvs_en     <= '1' when opcode = "1010" else '0';

    lw_en      <= '1' when opcode = "1100" else '0';
    sw_en      <= '1' when opcode = "1101" else '0';
    
    jump_en    <= '1' when opcode = "1111" else '0';

    -- lógica de branch condicional
    branch_condition_met <= '1' when (ble_en = '1' and (flag_z_in = '1' or (flag_n_in /= flag_v_in))) else
                            '1' when (bvs_en = '1' and flag_v_in = '1') else
                            '0';
    
    -- cálculo de endereço de branch relativo
    offset_s    <= signed(const_8_s);
    pc_relativo <= unsigned(resize(signed(pc_atual) + offset_s, 7));

    -- lógica do PC
    pc_prox <= jump_addr_s when (jump_en = '1' and estado_s = "10") else
               pc_relativo when ((ble_en = '1' or bvs_en = '1') and branch_condition_met = '1' and estado_s = "10") else
               (pc_atual + 1);
               
    wr_en_pc <= '1' when estado_s = "00" else
                '1' when (jump_en = '1' and estado_s = "10") else
                '1' when ((ble_en = '1' or bvs_en = '1') and branch_condition_met = '1' and estado_s = "10") else
                '0';
    
    -- lógica do RI
    wr_en_ri <= '1' when estado_s = "01" else '0';

    -- saídas de debug
    pc_out     <= pc_atual;
    estado_out <= estado_s;
    
    -- write enables
    wr_en_banco <= '1' when (estado_s = "10" and (li_en = '1' or mov_ra_en = '1') and nop_en = '0') else '0';
    
    wr_en_acum  <= '1' when (estado_s = "10" and (mov_ar_en = '1' or add_ar_en = '1' or addi_ac_en = '1' or sub_ar_en = '1') and nop_en = '0' and cmpr_en = '0') else
                 '1' when (estado_s = "11" and lw_en = '1') else
                 '0';

    wr_en_flags <= '1' when (estado_s = "10" and (add_ar_en = '1' or addi_ac_en = '1' or sub_ar_en = '1' or cmpr_en = '1')) else '0';

    wr_en_ram <= '1' when (estado_s = "11" and sw_en = '1') else '0';

    -- seleção de registradores
    sel_reg_wr <= reg_dest_s when (estado_s = "10" and (li_en = '1' or mov_ra_en = '1')) else "000";
    sel_reg_rd <= reg_font_s when (estado_s = "10" and (mov_ar_en = '1' or add_ar_en = '1' or sub_ar_en = '1' or cmpr_en = '1' or lw_en = '1' or sw_en = '1')) else
                reg_font_s when (estado_s = "11" and (lw_en = '1' or sw_en = '1')) else
                "000";

    -- seleção dos muxes
    sel_mux_banco <= "01" when (estado_s = "10" and li_en = '1') else
                     "00" when (estado_s = "10" and mov_ra_en = '1') else
                     "00";
    
    sel_mux_acum <= "01" when (estado_s = "10" and mov_ar_en = '1') else
                    "10" when (estado_s = "11" and lw_en = '1') else
                    "00";
    
    sel_mux_ula_y <= '1' when (estado_s = "10" and addi_ac_en = '1') else
                     '0';

    sel_ula <= "00" when (estado_s = "10" and (add_ar_en = '1' or addi_ac_en = '1')) else
               "01" when (estado_s = "10" and (sub_ar_en = '1' or cmpr_en = '1')) else
               "00";
    
    constante_out <= unsigned(resize(signed(const_8_s), 16));

end architecture;

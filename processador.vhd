library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk : in std_logic;
        rst : in std_logic;
        
        estado_out     : out unsigned(1 downto 0);
        pc_debug       : out unsigned(6 downto 0);
        instr_debug    : out unsigned(14 downto 0);
        acum_out_debug : out unsigned(15 downto 0);
        banco_out_debug: out unsigned(15 downto 0)
    );
end entity;

architecture a_processador of processador is
    component unidade_controle is
        port(
            clk           : in std_logic;
            rst           : in std_logic;
            instr_in      : in unsigned(14 downto 0);
            pc_out        : out unsigned(6 downto 0);
            estado_out    : out unsigned(1 downto 0);
            wr_en_pc      : out std_logic;
            wr_en_ri      : out std_logic;
            wr_en_banco   : out std_logic;
            wr_en_acum    : out std_logic;
            sel_reg_rd    : out unsigned(2 downto 0);
            sel_reg_wr    : out unsigned(2 downto 0);
            sel_ula       : out unsigned(1 downto 0);
            sel_mux_acum  : out std_logic;
            sel_mux_banco : out unsigned(1 downto 0);
            sel_mux_ula_y : out std_logic;
            constante_out : out unsigned(15 downto 0)
        );
    end component;

    component rom is
        port(
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(14 downto 0)
        );
    end component;
    
    component reg16bits is
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component top_level_banco_ula is
        port(
            clk             : in std_logic;
            rst             : in std_logic;
            wr_en_banco     : in std_logic;
            wr_en_acum      : in std_logic;
            sel_reg_rd      : in unsigned(2 downto 0);
            sel_reg_wr      : in unsigned(2 downto 0);
            sel_ula         : in unsigned(1 downto 0);
            sel_mux_acum    : in std_logic;
            sel_mux_banco   : in unsigned(1 downto 0);
            sel_mux_ula_y   : in std_logic;
            constante       : in unsigned(15 downto 0);
            flag_zero       : out std_logic;
            flag_carry      : out std_logic;
            data_out_acum   : out unsigned(15 downto 0);
            data_out_banco  : out unsigned(15 downto 0)
        );
    end component;

    signal s_pc_out        : unsigned(6 downto 0);
    signal s_rom_dado      : unsigned(14 downto 0);
    signal s_ri_out        : unsigned(15 downto 0);
    signal s_instr_15bit   : unsigned(14 downto 0);
    
    signal s_wr_en_pc      : std_logic;
    signal s_wr_en_ri      : std_logic;
    signal s_wr_en_banco   : std_logic;
    signal s_wr_en_acum    : std_logic;
    
    signal s_sel_reg_rd    : unsigned(2 downto 0);
    signal s_sel_reg_wr    : unsigned(2 downto 0);
    signal s_sel_ula       : unsigned(1 downto 0);
    signal s_sel_mux_acum  : std_logic;
    signal s_sel_mux_banco : unsigned(1 downto 0);
    signal s_sel_mux_ula_y : std_logic;
    signal s_constante     : unsigned(15 downto 0);

begin
    uc_inst: unidade_controle port map(
        clk           => clk,
        rst           => rst,
        instr_in      => s_instr_15bit,
        pc_out        => s_pc_out,
        estado_out    => estado_out,
        wr_en_pc      => s_wr_en_pc,
        wr_en_ri      => s_wr_en_ri,
        wr_en_banco   => s_wr_en_banco,
        wr_en_acum    => s_wr_en_acum,
        sel_reg_rd    => s_sel_reg_rd,
        sel_reg_wr    => s_sel_reg_wr,
        sel_ula       => s_sel_ula,
        sel_mux_acum  => s_sel_mux_acum,
        sel_mux_banco => s_sel_mux_banco,
        sel_mux_ula_y => s_sel_mux_ula_y,
        constante_out => s_constante
    );

    rom_inst: rom port map(
        clk      => clk,
        endereco => s_pc_out,
        dado     => s_rom_dado
    );
    
    ri_inst: reg16bits port map(
        clk      => clk,
        rst      => rst,
        wr_en    => s_wr_en_ri,
        data_in  => '0' & s_rom_dado,
        data_out => s_ri_out
    );
    
    -- converte a saída de 16 bits do RI de volta para 15 bits para a UC
    s_instr_15bit <= s_ri_out(14 downto 0);

    datapath_inst: top_level_banco_ula port map(
        clk             => clk,
        rst             => rst,
        wr_en_banco     => s_wr_en_banco,
        wr_en_acum      => s_wr_en_acum,
        sel_reg_rd      => s_sel_reg_rd,
        sel_reg_wr      => s_sel_reg_wr,
        sel_ula         => s_sel_ula,
        sel_mux_acum    => s_sel_mux_acum,
        sel_mux_banco   => s_sel_mux_banco,
        sel_mux_ula_y   => s_sel_mux_ula_y,
        constante       => s_constante,
        data_out_acum   => acum_out_debug,
        data_out_banco  => banco_out_debug
    );

    pc_debug    <= s_pc_out;
    instr_debug <= s_instr_15bit;

end architecture;
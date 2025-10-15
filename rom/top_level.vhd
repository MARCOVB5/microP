library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        clk        : in std_logic;
        rst        : in std_logic;
        pc_out     : out unsigned(6 downto 0);
        instr_out  : out unsigned(14 downto 0);
        estado_out : out std_logic
    );
end entity;

architecture a_top_level of top_level is
    component rom is
        port(
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(14 downto 0)
        );
    end component;
    
    component unidade_controle is
        port(
            clk       : in std_logic;
            rst       : in std_logic;
            instr     : in unsigned(14 downto 0);
            pc_out    : out unsigned(6 downto 0);
            estado_out : out std_logic
        );
    end component;
    
    signal pc_s    : unsigned(6 downto 0);
    signal instr_s : unsigned(14 downto 0);
    signal estado_s : std_logic;
    
begin
    rom_inst: rom port map(
        clk      => clk,
        endereco => pc_s,
        dado     => instr_s
    );
    
    uc_inst: unidade_controle port map(
        clk       => clk,
        rst       => rst,
        instr     => instr_s,
        pc_out    => pc_s,
        estado_out => estado_s);
    
    pc_out <= pc_s;
    instr_out <= instr_s;
    estado_out <= estado_s;
    
end architecture;

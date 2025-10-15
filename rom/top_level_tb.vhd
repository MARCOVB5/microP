library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end entity;

architecture a_top_level_tb of top_level_tb is
    component top_level is
        port(
            clk        : in std_logic;
            rst        : in std_logic;
            pc_out     : out unsigned(6 downto 0);
            instr_out  : out unsigned(14 downto 0);
            estado_out : out std_logic);
    end component;
    
    signal clk_s        : std_logic := '0';
    signal rst_s        : std_logic := '0';
    signal pc_s         : unsigned(6 downto 0);
    signal instr_s      : unsigned(14 downto 0);
    signal estado_s     : std_logic;
    
    constant periodo    : time := 10 ns;
    
begin
    uut: top_level port map(
        clk        => clk_s,
        rst        => rst_s,
        pc_out     => pc_s,
        instr_out  => instr_s,
        estado_out => estado_s
    );
    
    clk_s <= not clk_s after periodo/2;
    
    process
    begin
        rst_s <= '1';
        wait for periodo*2;
        
        rst_s <= '0';
        wait for periodo*30;
        
        wait;
    end process;
    
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados_tb is
end entity;

architecture a_maq_estados_tb of maq_estados_tb is
    component maq_estados is
        port(
            clk    : in std_logic;
            rst    : in std_logic;
            estado : out std_logic);
    end component;
    
    signal clk_s    : std_logic := '0';
    signal rst_s    : std_logic := '0';
    signal estado_s : std_logic;
    
    constant periodo : time := 10 ns;
    
begin
    uut: maq_estados port map(
        clk    => clk_s,
        rst    => rst_s,
        estado => estado_s);
    
    clk_s <= not clk_s after periodo/2;
    
    process
    begin
        rst_s <= '1';
        wait for periodo;
        
        rst_s <= '0';
        wait for periodo*10;
        
        wait;
    end process;
    
end architecture;

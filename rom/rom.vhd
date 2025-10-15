library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(   clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(14 downto 0));
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(14 downto 0);
    constant conteudo_rom : mem := (
        0  => "111100000000011",  
        1  => "000000000000000",  
        2  => "000000000000000",  
        3  => "000000000000000",  
        4  => "111100000000111",  
        5  => "000000000000000",  
        6  => "000000000000000",  
        7  => "000000000000000", 
        8  => "111100000000000", 
        others => (others=>'0'));
        
    begin 
        process(clk)
        begin
            if(rising_edge(clk)) then
                dado <= conteudo_rom(to_integer(endereco));
            end if;
        end process;
end architecture;

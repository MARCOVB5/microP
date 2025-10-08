-- ULA (16/09/2025)
-- Gabriel Afonso Borges Caballero e Marco Vieira Busetti

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port (x, y : in unsigned(15 downto 0);
          sel : in unsigned(1 downto 0);
          flag_zero, flag_carry : out std_logic;
          saida : out unsigned(15 downto 0));
end entity;

architecture a_ula of ula is
    signal resultado : unsigned(15 downto 0);
    signal resultado_soma : unsigned(16 downto 0);
    signal resultado_sub : unsigned(16 downto 0);
begin
    resultado_soma <= ('0' & x) + ('0' & y);
    resultado_sub <= ('0' & x) - ('0' & y);
    
    resultado <= resultado_soma(15 downto 0) when sel="00" else
                 resultado_sub(15 downto 0) when sel="01" else
                 not (x and y) when sel="10" else
                 x xor y when sel="11" else
                 "0000000000000000";
    
    flag_zero <= '1' when resultado="0000000000000000" else '0';
    
    flag_carry <= resultado_soma(16) when sel="00" else
                  resultado_sub(16) when sel="01" else
                  '0';
    
    saida <= resultado;
end architecture;

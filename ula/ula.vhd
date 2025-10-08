-- ULA (16/09/2025)
-- Gabriel Afonso Borges Caballero e Marco Vieira Busetti

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	port (x, y : in unsigned(15 downto 0); -- entradas de 16 bits
		  sel : in unsigned(1 downto 0); --seleção de operação
		  flag_zero, flag_carry : out std_logic; --flags para status da operação
	      saida : out unsigned(15 downto 0));
end entity;

architecture a_ula of ula is
begin
	saida <= x+y when sel="00" else -- operação de soma
			 x-y when sel="01" else -- operação de subtração
			 not (x and y) when sel="10" else --operação de nand
			 x xor y when sel="11" else --operação de xor
			  "0000000000000000";
end architecture;

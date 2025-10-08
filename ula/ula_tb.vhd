-- ULA Testbench (16/09/2025)
-- Gabriel Afonso Borges Caballero e Marco Vieira Busetti

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
	component ula
		port (x, y : in unsigned(15 downto 0); -- entradas de 16 bits
              sel : in unsigned(1 downto 0); --seleção de operação
              flag_zero, flag_carry : out std_logic; --flags para status da operação
              saida : out unsigned(15 downto 0));
	end component;
	signal x,y,saida : unsigned(15 downto 0);
	signal sel : unsigned(1 downto 0);
	signal flag_zero, flag_carry : std_logic;

	begin 
		uut: ula port map(x=>x,y=>y,sel=>sel,flag_zero=>flag_zero,flag_carry=>flag_carry,saida=>saida);

	process -- dados de simulação para a ULA
	begin
		-- Teste 1: Soma básica
		x <= "0000000000000101"; -- 5
		y <= "0000000000000011"; -- 3  
		sel <= "00";
		wait for 10 ns;

		-- Teste 2: Soma com carry
		x <= "1111111111111111"; -- 65535
		y <= "0000000000000001"; -- 1
		sel <= "00"; 
		wait for 10 ns;

		-- Teste 3: Subtração básica
		x <= "0000000000001010"; -- 10
		y <= "0000000000000100"; -- 4
		sel <= "01";
		wait for 10 ns;

		-- Teste 4: Subtração resultando negativo
		x <= "0000000000000011"; -- 3
		y <= "0000000000000101"; -- 5
		sel <= "01";
		wait for 10 ns;

		-- Teste 5: NAND com todos bits 1
		x <= "1111111111111111"; -- 65535
		y <= "1111111111111111"; -- 65535
		sel <= "10";
		wait for 10 ns;

		-- Teste 6: NAND com padrão misto
		x <= "1010101010101010"; 
		y <= "0101010101010101";
		sel <= "10";
		wait for 10 ns;

		-- Teste 7: XOR idênticos (resultado zero)
		x <= "0000111100001111";
		y <= "0000111100001111";
		sel <= "11";
		wait for 10 ns;

		-- Teste 8: XOR diferentes
		x <= "1111000011110000";
		y <= "0000111100001111";
		sel <= "11";
		wait for 10 ns;
		wait;
	end process;

end architecture;					

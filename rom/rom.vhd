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
        0  => B"0001_000_00110010",  -- 0: LI R0, 50
        1  => B"0001_001_01001001",  -- 1: LI R1, 73
        2  => B"0001_010_00110010",  -- 2: LI R2, 50
        3  => B"0001_011_01111011",  -- 3: LI R3, 123

        4  => B"0010_000_010_00000",  -- 4: MOV A, R2
        5  => B"1101_000_000_00000",  -- 5: SW (R0)
        6  => B"0010_000_011_00000",  -- 6: MOV A, R3
        7  => B"1101_000_001_00000",  -- 7: SW (R1)

        8  => B"0001_100_00000000",  -- 8: LI R4, 0
        9  => B"0001_101_00000000",  -- 9: LI R5, 0
        10 => B"0010_000_100_00000",  -- 10: MOV A, R4

        11 => B"1100_000_000_00000",  -- 11: LW (R0)
        12 => B"0011_100_000_00000",  -- 12: MOV R4, A
        13 => B"1100_000_001_00000",  -- 13: LW (R1)
        14 => B"0011_101_000_00000",  -- 14: MOV R5, A

        15 => B"1111_0001111_0000",  -- 15: JMP 15

        others => B"0000_000_000_00000" -- NOP
    );
begin 
    process(clk)
    begin
        if(rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
end if;
    end process;
end architecture;

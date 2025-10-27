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
        0  => B"0001_011_00000101",  -- 0: LI R3, 5
        1  => B"0001_100_00001000",  -- 1: LI R4, 8
        2  => B"0001_110_00000001",  -- 2: LI R6, 1 (constante para subtração)
        
        3  => B"0010_000_011_00000",  -- 3: (C) MOV_A_R Acum, R3 (Início do Loop)
        4  => B"0100_000_100_00000",  -- 4: ADD_A_R Acum, R4
        5  => B"0011_101_000_00000",  -- 5: MOV_R_A R5, Acum
        
        6  => B"0010_000_101_00000",  -- 6: (D) MOV_A_R Acum, R5
        7  => B"0110_000_110_00000",  -- 7: SUB_A_R Acum, R6 (Usa R6 p/ subtrair 1)
        8  => B"0011_101_000_00000",  -- 8: MOV_R_A R5, Acum
        
        9  => B"1111_0010100_0000",  -- 9: (E) JMP 20
        10 => B"0001_101_00000000",  -- 10: (F) LI R5, 0 (Ignorado)

        11 => B"000000000000000", -- NOP
        12 => B"000000000000000", -- NOP
        13 => B"000000000000000", -- NOP
        14 => B"000000000000000", -- NOP
        15 => B"000000000000000", -- NOP
        16 => B"000000000000000", -- NOP
        17 => B"000000000000000", -- NOP
        18 => B"000000000000000", -- NOP
        19 => B"000000000000000", -- NOP
        
        20 => B"0010_000_101_00000",  -- 20: (G) MOV_A_R Acum, R5
        21 => B"0011_011_000_00000",  -- 21: MOV_R_A R3, Acum
        22 => B"1111_0000011_0000",  -- 22: (H) JMP 3 (Novo início do loop)
        23 => B"0001_011_00000000",  -- 23: (I) LI R3, 0 (Ignorado)

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

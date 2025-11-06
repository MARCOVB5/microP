library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_lab5 is
    port(   clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(14 downto 0));
end entity;

architecture a_rom_lab5 of rom_lab5 is
    type mem is array (0 to 127) of unsigned(14 downto 0);

    constant conteudo_rom : mem := (
        0  => B"0001_011_00000101",  -- 0: (A) LI R3, 5
        1  => B"0001_100_00001000",  -- 1: (B) LI R4, 8
        
        2  => B"0010_000_011_00000",  -- 2: (C) MOV A, R3 (início do loop)
        3  => B"0100_000_100_00000",  -- 3: ADD A, R4
        4  => B"0011_101_000_00000",  -- 4: MOV R5, A
        
        5  => B"0010_000_101_00000",  -- 5: (D) MOV A, R5
        6  => B"0101_000_11111111",  -- 6: ADDI A, -1
        7  => B"0011_101_000_00000",  -- 7: MOV R5, A
        
        8  => B"1111_0010100_0000",  -- 8: (E) JMP 20
        9  => B"0001_101_00000000",  -- 9: (F) LI R5, 0 (ignorado)

        10 => B"000000000000000", -- NOP
        11 => B"000000000000000", -- NOP
        12 => B"000000000000000", -- NOP
        13 => B"000000000000000", -- NOP
        14 => B"000000000000000", -- NOP
        15 => B"000000000000000", -- NOP
        16 => B"000000000000000", -- NOP
        17 => B"000000000000000", -- NOP
        18 => B"000000000000000", -- NOP
        19 => B"000000000000000", -- NOP
        
        20 => B"0010_000_101_00000",  -- 20: (G) MOV A, R5
        21 => B"0011_011_000_00000",  -- 21: MOV R3, A
        22 => B"1111_0000010_0000",  -- 22: (H) JMP 2 (fim do loop)
        23 => B"0001_011_00000000",  -- 23: (I) LI R3, 0 (ignorado)

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

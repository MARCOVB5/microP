library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_teste is
    port(   clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(14 downto 0));
end entity;

architecture a_rom_teste of rom_teste is
    type mem is array (0 to 127) of unsigned(14 downto 0);
    constant conteudo_rom : mem := (
        0  => B"0000_000_000_00000", -- NOP
        1  => B"0001_000_00000101", -- LI R0, 5
        2  => B"0001_001_00000010", -- LI R1, 2
        3  => B"0010_000_000_00000", -- MOV A, R0
        
        4  => B"0100_000_001_00000", -- ADD A, R1
        5  => B"0011_010_000_00000", -- MOV R2, A
        6  => B"0101_000_00000011", -- ADDI A, 3
        7  => B"0110_000_001_00000", -- SUB A, R1
        
        8  => B"0111_000_001_00000", -- AND A, R1
        9  => B"0001_000_00000111", -- LI R0, 7
        10 => B"0010_000_000_00000", -- MOV A, R0
        11 => B"0111_000_001_00000", -- AND A, R1
        
        12 => B"0001_100_00110010", -- LI R4, 50
        13 => B"1101_000_100_00000", -- SW (R4)
        14 => B"0001_000_00000000", -- LI R0, 0
        15 => B"0010_000_000_00000", -- MOV A, R0
        16 => B"1100_000_100_00000", -- LW (R4)
        17 => B"0011_101_000_00000", -- MOV R5, A

        18 => B"0001_000_00000101", -- LI R0, 5
        19 => B"0010_000_000_00000", -- MOV A, R0
        20 => B"1000_000_001_00000", -- CMPR A, R1
        21 => B"1001_000_00000010", -- BLE +2
        
        22 => B"1111_0011000_0000", -- JMP 24
        23 => B"0001_101_11111111", -- LI R5, 255
        
        24 => B"1000_000_010_00000", -- CMPR A, R2
        25 => B"1001_000_00000010", -- BLE +2
        26 => B"0001_101_11111111", -- LI R5, 255
        
        27 => B"0000_000_000_00000", -- NOP
        28 => B"1010_000_00000000", -- BVS +0

        29 => B"1110_000_000_00000", -- HALT
        
        others => B"0000_000_000_00000" -- NOP
    );
begin 
    process(clk) begin
        if(rising_edge(clk)) then dado <= conteudo_rom(to_integer(endereco)); end if;
    end process;
end architecture;
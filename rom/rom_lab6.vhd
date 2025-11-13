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
        0  => B"0001_011_00000000",  -- 0: (A) LI R3, 0
        1  => B"0001_100_00000000",  -- 1: (B) LI R4, 0
        2  => B"0001_000_00011101",  -- 2: LI R0, 29
        
        3  => B"0010_000_011_00000",  -- 3: (C) MOV A, R3 (início do loop)
        4  => B"0100_000_100_00000",  -- 4: ADD A, R4
        5  => B"0011_100_000_00000",  -- 5: MOV R4, A
        
        6  => B"0010_000_011_00000",  -- 6: (D) MOV A, R3
        7  => B"0101_000_00000001",  -- 7: ADDI A, 1
        8  => B"0011_011_000_00000",  -- 8: MOV R3, A

        9 => B"1000_000_000_00000",  -- 9: (E) CMPR A, R0
        10 => B"1001_000_11111000",  -- 10: BLE -8
        
        11 => B"0010_000_100_00000",  -- 11: (F) MOV A, R4
        12 => B"0011_101_000_00000",  -- 12: MOV R5, A

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

-- Banco de Registradores (08/10/2025)
-- Gabriel Afonso Borges Caballero e Marco Vieira Busetti

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_registradores is
    port(
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        sel_reg_rd : in unsigned(2 downto 0);
        sel_reg_wr : in unsigned(2 downto 0);
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_banco_registradores of banco_registradores is
    component reg16bits is
        port(
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    
    signal wr_en_r0, wr_en_r1, wr_en_r2, wr_en_r3, wr_en_r4, wr_en_r5 : std_logic;
    signal data_r0, data_r1, data_r2, data_r3, data_r4, data_r5 : unsigned(15 downto 0);
    
begin
    wr_en_r0 <= '1' when wr_en='1' and sel_reg_wr="000" else '0';
    wr_en_r1 <= '1' when wr_en='1' and sel_reg_wr="001" else '0';
    wr_en_r2 <= '1' when wr_en='1' and sel_reg_wr="010" else '0';
    wr_en_r3 <= '1' when wr_en='1' and sel_reg_wr="011" else '0';
    wr_en_r4 <= '1' when wr_en='1' and sel_reg_wr="100" else '0';
    wr_en_r5 <= '1' when wr_en='1' and sel_reg_wr="101" else '0';
    
    r0: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en_r0, data_in=>data_in, data_out=>data_r0);
    r1: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en_r1, data_in=>data_in, data_out=>data_r1);
    r2: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en_r2, data_in=>data_in, data_out=>data_r2);
    r3: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en_r3, data_in=>data_in, data_out=>data_r3);
    r4: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en_r4, data_in=>data_in, data_out=>data_r4);
    r5: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en_r5, data_in=>data_in, data_out=>data_r5);
    
    data_out <= data_r0 when sel_reg_rd="000" else
                data_r1 when sel_reg_rd="001" else
                data_r2 when sel_reg_rd="010" else
                data_r3 when sel_reg_rd="011" else
                data_r4 when sel_reg_rd="100" else
                data_r5 when sel_reg_rd="101" else
                "0000000000000000";
end architecture;

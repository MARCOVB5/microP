-- Top-Level _ Banco de Registradores (08/10/2025)
-- Gabriel Afonso Borges Caballero e Marco Vieira Busetti

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_banco_ula is
    port(
        clk : in std_logic;
        rst : in std_logic;
        wr_en_banco : in std_logic;
        wr_en_acum : in std_logic;
        sel_reg_rd : in unsigned(2 downto 0);
        sel_reg_wr : in unsigned(2 downto 0);
        sel_ula : in unsigned(1 downto 0);
        sel_mux_acum : in std_logic;
        sel_mux_banco : in unsigned(1 downto 0);
        constante : in unsigned(15 downto 0);
        flag_zero : out std_logic;
        flag_carry : out std_logic;
        data_out_acum : out unsigned(15 downto 0);
        data_out_banco : out unsigned(15 downto 0)
    );
end entity;

architecture a_top_level_banco_ula of top_level_banco_ula is
    component banco_registradores is
        port(
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            sel_reg_rd : in unsigned(2 downto 0);
            sel_reg_wr : in unsigned(2 downto 0);
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    
    component ula is
        port(
            x, y : in unsigned(15 downto 0);
            sel : in unsigned(1 downto 0);
            flag_zero, flag_carry : out std_logic;
            saida : out unsigned(15 downto 0)
        );
    end component;
    
    component reg16bits is
        port(
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    
    signal data_banco_out : unsigned(15 downto 0);
    signal data_acum : unsigned(15 downto 0);
    signal saida_ula : unsigned(15 downto 0);
    signal entrada_acum : unsigned(15 downto 0);
    signal entrada_banco : unsigned(15 downto 0);
    
begin
    banco: banco_registradores port map(
        clk=>clk,
        rst=>rst,
        wr_en=>wr_en_banco,
        sel_reg_rd=>sel_reg_rd,
        sel_reg_wr=>sel_reg_wr,
        data_in=>entrada_banco,
        data_out=>data_banco_out
    );
    
    acumulador: reg16bits port map(
        clk=>clk,
        rst=>rst,
        wr_en=>wr_en_acum,
        data_in=>entrada_acum,
        data_out=>data_acum
    );
    
    ula_inst: ula port map(
        x=>data_acum,
        y=>data_banco_out,
        sel=>sel_ula,
        flag_zero=>flag_zero,
        flag_carry=>flag_carry,
        saida=>saida_ula
    );
    
    entrada_acum <= data_banco_out when sel_mux_acum='1' else
                    saida_ula;
    
    entrada_banco <= data_acum when sel_mux_banco="00" else
                     constante when sel_mux_banco="01" else
                     saida_ula when sel_mux_banco="10" else
                     "0000000000000000";
    
    data_out_acum <= data_acum;
    data_out_banco <= data_banco_out;
end architecture;

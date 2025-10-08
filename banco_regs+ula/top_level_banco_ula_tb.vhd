-- Top Level _ Banco de Registradores Testbench (08/10/2025)
-- Gabriel Afonso Borges Caballero e Marco Vieira Busetti

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_banco_ula_tb is
end;

architecture a_top_level_banco_ula_tb of top_level_banco_ula_tb is
    component top_level_banco_ula is
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
            sel_mux_ula_y : in std_logic;
            constante : in unsigned(15 downto 0);
            flag_zero : out std_logic;
            flag_carry : out std_logic;
            data_out_acum : out unsigned(15 downto 0);
            data_out_banco : out unsigned(15 downto 0)
        );
    end component;
    
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
    signal clk, rst : std_logic;
    signal wr_en_banco, wr_en_acum : std_logic;
    signal sel_reg_rd, sel_reg_wr : unsigned(2 downto 0);
    signal sel_ula : unsigned(1 downto 0);
    signal sel_mux_acum : std_logic;
    signal sel_mux_banco : unsigned(1 downto 0);
    signal sel_mux_ula_y : std_logic;
    signal constante : unsigned(15 downto 0);
    signal flag_zero, flag_carry : std_logic;
    signal data_out_acum, data_out_banco : unsigned(15 downto 0);
    
begin
    uut: top_level_banco_ula port map(
        clk=>clk,
        rst=>rst,
        wr_en_banco=>wr_en_banco,
        wr_en_acum=>wr_en_acum,
        sel_reg_rd=>sel_reg_rd,
        sel_reg_wr=>sel_reg_wr,
        sel_ula=>sel_ula,
        sel_mux_acum=>sel_mux_acum,
        sel_mux_banco=>sel_mux_banco,
        sel_mux_ula_y=>sel_mux_ula_y,
        constante=>constante,
        flag_zero=>flag_zero,
        flag_carry=>flag_carry,
        data_out_acum=>data_out_acum,
        data_out_banco=>data_out_banco
    );
    
    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2;
        rst <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 5 us;
        finished <= '1';
        wait;
    end process sim_time_proc;
    
    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;
    
    process
    begin
        wait for 200 ns;
        
        wr_en_banco <= '1';
        wr_en_acum <= '0';
        sel_reg_wr <= "000";
        sel_mux_banco <= "01";
        sel_mux_ula_y <= '0';
        constante <= "0000000000000101";
        sel_mux_acum <= '0';
        wait for 100 ns;
        
        wr_en_banco <= '1';
        sel_reg_wr <= "001";
        constante <= "0000000000001010";
        wait for 100 ns;
        
        wr_en_banco <= '1';
        sel_reg_wr <= "010";
        constante <= "0000000000001111";
        wait for 100 ns;
        
        wr_en_banco <= '0';
        wr_en_acum <= '1';
        sel_reg_rd <= "000";
        sel_mux_acum <= '1';
        sel_mux_ula_y <= '0';
        wait for 100 ns;
        
        wr_en_acum <= '1';
        sel_reg_rd <= "001";
        sel_ula <= "00";
        sel_mux_acum <= '0';
        sel_mux_ula_y <= '0';
        wait for 100 ns;
        
        wr_en_acum <= '1';
        sel_mux_ula_y <= '1';
        constante <= "0000000000000011";
        sel_ula <= "00";
        sel_mux_acum <= '0';
        wait for 100 ns;
        
        wr_en_banco <= '1';
        wr_en_acum <= '0';
        sel_reg_wr <= "011";
        sel_mux_banco <= "00";
        sel_mux_ula_y <= '0';
        wait for 100 ns;
        
        wr_en_banco <= '0';
        wr_en_acum <= '1';
        sel_reg_rd <= "011";
        sel_ula <= "01";
        sel_mux_acum <= '0';
        sel_mux_ula_y <= '0';
        wait for 100 ns;
        
        wr_en_banco <= '1';
        wr_en_acum <= '0';
        sel_reg_wr <= "100";
        sel_mux_banco <= "00";
        wait for 100 ns;
        
        wr_en_banco <= '0';
        wr_en_acum <= '1';
        sel_reg_rd <= "000";
        sel_ula <= "10";
        sel_mux_acum <= '0';
        sel_mux_ula_y <= '0';
        wait for 100 ns;
        
        wr_en_acum <= '1';
        sel_reg_rd <= "001";
        sel_ula <= "11";
        sel_mux_acum <= '0';
        sel_mux_ula_y <= '0';
        wait for 100 ns;
        
        wait;
    end process;
end architecture;

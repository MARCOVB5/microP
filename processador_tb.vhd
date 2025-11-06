library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
    component processador is
        port(
            clk : in std_logic;
            rst : in std_logic;
            estado_out     : out unsigned(1 downto 0);
            pc_debug       : out unsigned(6 downto 0);
            instr_debug    : out unsigned(14 downto 0);
            acum_out_debug : out unsigned(15 downto 0);
            banco_out_debug: out unsigned(15 downto 0)
        );
    end component;
    
    constant period_time : time := 10 ns;
    signal finished      : std_logic := '0';
    signal clk_s, rst_s  : std_logic;
    
    signal estado_s      : unsigned(1 downto 0);
    signal pc_s          : unsigned(6 downto 0);
    signal instr_s       : unsigned(14 downto 0);
    signal acum_s        : unsigned(15 downto 0);
    signal banco_s       : unsigned(15 downto 0);
    
begin
    uut: processador port map(
        clk             => clk_s,
        rst             => rst_s,
        estado_out      => estado_s,
        pc_debug        => pc_s,
        instr_debug     => instr_s,
        acum_out_debug  => acum_s,
        banco_out_debug => banco_s
    );

    reset_global: process
    begin
        rst_s <= '1';
        wait for period_time*2;
        rst_s <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process sim_time_proc;
    
    clk_proc: process
    begin
        while finished /= '1' loop
            clk_s <= '0';
            wait for period_time/2;
            clk_s <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

end architecture;
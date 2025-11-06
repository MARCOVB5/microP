library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flags is
    port(
        clk     : in std_logic;
        rst     : in std_logic;
        wr_en   : in std_logic;
        Z_in, C_in, V_in, N_in : in std_logic;
        Z_out, C_out, V_out, N_out : out std_logic
    );
end entity;

architecture a_flags of flags is
    signal Z_s, C_s, V_s, N_s : std_logic;
begin
    process(clk, rst)
    begin
        if rst='1' then
            Z_s <= '0';
            C_s <= '0';
            V_s <= '0';
            N_s <= '0';
        elsif rising_edge(clk) then
            if wr_en='1' then
                Z_s <= Z_in;
                C_s <= C_in;
                V_s <= V_in;
                N_s <= N_in;
            end if;
        end if;
    end process;
    
    Z_out <= Z_s;
    C_out <= C_s;
    V_out <= V_s;
    N_out <= N_s;
    
end architecture;

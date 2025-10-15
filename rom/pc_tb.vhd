library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end entity;

architecture a_pc_tb of pc_tb is
    component pc is
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0));
    end component;
    
    signal clk_s      : std_logic := '0';
    signal rst_s      : std_logic := '0';
    signal wr_en_s    : std_logic := '0';
    signal data_in_s  : unsigned(6 downto 0) := (others => '0');
    signal data_out_s : unsigned(6 downto 0);
    
    constant periodo : time := 10 ns;
    
begin
    uut: pc port map(
        clk      => clk_s,
        rst      => rst_s,
        wr_en    => wr_en_s,
        data_in  => data_in_s,
        data_out => data_out_s);
    
    clk_s <= not clk_s after periodo/2;
    
    process
    begin
        rst_s <= '1';
        wr_en_s <= '0';
        data_in_s <= "0000000";
        wait for periodo;
        
        rst_s <= '0';
        wr_en_s <= '1';
        data_in_s <= "0000001";
        wait for periodo;
        
        data_in_s <= "0000010";
        wait for periodo;
        
        data_in_s <= "0000011";
        wait for periodo;
        
        data_in_s <= "0000100";
        wait for periodo;
        
        data_in_s <= "0000101";
        wait for periodo;
        
        data_in_s <= "0000110";
        wait for periodo;
        
        data_in_s <= "0000111";
        wait for periodo;
        
        data_in_s <= "0001000";
        wait for periodo;
        
        wr_en_s <= '0';
        wait for periodo;
        wait for periodo;
        
        wait;
    end process;
    
end architecture;

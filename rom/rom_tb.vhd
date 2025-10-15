library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
    component rom is
        port( 	clk			: in std_logic;
                endereco	: in unsigned(6 downto 0);
                dado		: out unsigned(14 downto 0));
    end component;
    
    signal clk_s      : std_logic := '0';
    signal endereco_s : unsigned(6 downto 0) := (others => '0');
    signal dado_s     : unsigned(14 downto 0);
    
    constant periodo  : time := 10 ns;
    
begin
    uut: rom port map(
        clk      => clk_s,
        endereco => endereco_s,
        dado     => dado_s);
    
    clk_s <= not clk_s after periodo/2;
    
    process
    begin
        endereco_s <= "0000000";
        wait for periodo;
        
        endereco_s <= "0000001";
        wait for periodo;
        
        endereco_s <= "0000010";
        wait for periodo;
        
        endereco_s <= "0000011";
        wait for periodo;
        
        endereco_s <= "0000100";
        wait for periodo;
        
        endereco_s <= "0000101";
        wait for periodo;
        
        endereco_s <= "0000110";
        wait for periodo;
        
        endereco_s <= "0000111";
        wait for periodo;
        
        endereco_s <= "0001000";
        wait for periodo;
        
        endereco_s <= "0001001";
        wait for periodo;
        
        endereco_s <= "0001010";
        wait for periodo;
        
        wait;
    end process;
    
end architecture;

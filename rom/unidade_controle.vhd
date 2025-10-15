library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
    port(
        clk       : in std_logic;
        rst       : in std_logic;
        instr     : in unsigned(14 downto 0);
        pc_out    : out unsigned(6 downto 0);
        estado_out : out std_logic);
end entity;

architecture a_unidade_controle of unidade_controle is
    component pc is
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0));
    end component;
    
    component maq_estados is
        port(
            clk    : in std_logic;
            rst    : in std_logic;
            estado : out std_logic);
    end component;
    
    signal pc_atual : unsigned(6 downto 0);
    signal pc_prox  : unsigned(6 downto 0);
    signal estado_s : std_logic;
    signal wr_en_s  : std_logic;
    signal opcode   : unsigned(3 downto 0);
    signal jump_en  : std_logic;
    
begin
    opcode <= instr(14 downto 11);
    jump_en <= '1' when opcode="1111" else '0';
    pc_inst: pc port map(
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en_s,
        data_in  => pc_prox,
        data_out => pc_atual
    );
    
    maq_inst: maq_estados port map(
        clk    => clk,
        rst    => rst,
        estado => estado_s);
    
    wr_en_s <= '1' when estado_s='1' else '0';
    
    pc_prox <= instr(6 downto 0) when jump_en='1' else
               pc_atual + 1;
    
    pc_out <= pc_atual;
    estado_out <= estado_s;
    
end architecture;

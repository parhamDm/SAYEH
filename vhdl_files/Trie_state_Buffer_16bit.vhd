library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity trie_state_buffer_16bit is 
	port(
		control:in std_logic;
		input:in std_logic_vector(15 downto 0);
		output: out std_logic_vector(15 downto 0)
	);
end entity trie_state_buffer_16bit;

architecture behave of trie_state_buffer_16bit is 
begin
	tristate : for i in 0 to 15 generate
		output(i) <= input(i) when control = '1' else 'Z';
end generate tristate;
end architecture;
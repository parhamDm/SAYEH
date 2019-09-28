
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or_comp is
	port(
	Rs,Rd: in std_logic_vector(15 downto 0);
	output:out std_logic_vector(15 downto 0)
	);
end entity or_comp;

architecture behave of or_comp is
	begin
	a: for i in 0 to 15 generate 
		output(i)<=(Rd(i) or Rs(i));
	end generate a;
end;
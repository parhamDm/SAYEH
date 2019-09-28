
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_right_comp is
	port(
	Rs: in std_logic_vector(15 downto 0);
	output:out std_logic_vector(15 downto 0);
	carry: out std_logic
	);
end entity shift_right_comp;

architecture behave of shift_right_comp is
	begin
	carry <= RS(0);
	l : for i in 0 to 14 generate
		outPut(i)<= Rs(i+1);
	end generate l;
	output(15)<='0';
end;
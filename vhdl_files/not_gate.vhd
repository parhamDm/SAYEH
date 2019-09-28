library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity not_gate is
	port(
		RS     : in    std_logic_vector(15 downto 0);
		not_Rs : inout std_logic_vector(15 downto 0)
	);
end entity;

architecture RTL of not_gate is

begin
	a: for i in 0 to 15 generate 
	not_Rs(i)<= not RS(i);
	end generate;
end architecture RTL;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity andOp is
	port (
		Op : in std_logic;
		DataIn:in std_logic_vector(7 downto 0);
		outPut:out std_logic_vector(7 downto 0)
	);
end entity andOp;

architecture RTL of andOp is
	signal o:std_logic_vector(15 downto 0) ;
begin
	la:for i in 7 downto 0 generate
		outPut(i)<=op and DataIn(i);
	end generate;
	
end architecture RTL;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_Register is
	port(
		DataIn:in std_logic_vector(15 downto 0);
		clk,load:in std_logic;
		DataOut:out std_logic_vector(15 downto 0)
	);
end entity;

architecture behave of Instruction_Register is 
	signal output: std_logic_vector(15 downto 0);
begin	
	process(clk) begin
		if clk'event and clk='1' then
			if load='1' then
				output<=DataIn;
			end if;
		end if;
	end process;
	DataOut<=output;
end;
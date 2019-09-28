library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.numeric_std.all;

entity Window_Pointer is 
	port(
		clk,reset,load_sum: in std_logic;
		dataLoadIn:in std_logic_vector(5 downto 0);
		DataOut:out std_logic_vector(5 downto 0)
	);
end entity;

architecture behave of Window_Pointer is
	signal output: std_logic_vector(5 downto 0);
begin
	process(clk)
	begin
		if clk'event and clk='1' then
			if reset='1' then 
				output<="000000";
			elsif load_sum='1' then 
				output <= std_logic_vector(unsigned(output) + unsigned(dataLoadIn));
			end if;
			if output="UUUUUU" then 
				output<="000000"; 
			end if; 
		end if;
	end process;
	DataOut<=output;
end;
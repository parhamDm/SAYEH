
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity register16bit is
	port(
		DataIn                        : in  std_logic_vector(15 downto 0);
		highLoad, lowLoad, reset, clk : in  std_logic;
		DataOut                       : out std_logic_vector(15 downto 0):=X"0000"
	);
end entity;

architecture behave of register16bit is
begin
	process(clk)
	begin
		if clk'event and clk = '1' then
			if reset = '1' then
				DataOut(15 downto 8) <= "00000000";
				DataOut(7 downto 0)  <= "00000000";
			else
				if highLoad = '1' then
					DataOut(15 downto 8) <= DataIn(15 downto 8);
				end if;
				if lowLoad = '1' then
					DataOut(7 downto 0) <= DataIn(7 downto 0);
				end if;
			end if;
		end if;
	end process;
end;

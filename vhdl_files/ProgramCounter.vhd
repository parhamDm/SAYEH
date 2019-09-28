library IEEE;
use IEEE.Std_logic_1164.all;

entity ProgramCounter is
	port(
		EnablePc : IN  std_logic;
		input    : IN  std_logic_vector(15 downto 0);
		clk      : IN  std_logic;
		output   : out std_logic_vector(15 downto 0):= X"0000"
	);
end entity;

architecture dataflow of ProgramCounter is
begin
	process(clk)
	begin
		if (clk = '1') then
			if (EnablePc = '1') then
				output <= input;
			end if;
		end if;
	end process;
end architecture;

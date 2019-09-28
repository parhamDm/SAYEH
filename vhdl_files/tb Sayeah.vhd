library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity SAYEH_PROCESSOR_WIHT_RAM_tb is
end;

architecture bench of SAYEH_PROCESSOR_WIHT_RAM_tb is

	component sayeh_and_ram is
		port(
			clk : in std_logic;
			rst : in std_logic
		);
	end component sayeh_and_ram;

	signal clk                       : std_logic;
	signal data_pass, AU_out         : std_logic_vector(15 downto 0);
	signal carry_s_flag, zero_s_flag : std_logic;

	constant clock_period : time := 200 ns;
	signal stop_the_clock : boolean;

begin

	uut : sayeh_and_ram
		port map(
			clk => clk,
			rst => '1'
		);

	stimulus : process
	begin
		-- Put initialisation code here

		-- Put test bench stimulus code here
		wait for 100000 ns;
		wait;
	end process;

	clocking : process
	begin
		while not stop_the_clock loop
			clk <= '0', '1' after clock_period / 2;
			wait for clock_period;
		end loop;
		wait;
	end process;
end;

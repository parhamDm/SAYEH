library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparaor_16bit is 
port(
	a,b : in std_logic_vector(15 downto 0);
	eq,lo,gr : out std_logic;
  output:out std_logic_vector(15 downto 0)
);
end entity comparaor_16bit;
architecture behave of comparaor_16bit is

	component comprator is 
		port(
			g_in,l_in,e_in,a,b:in std_logic;
			g_out,l_out,e_out: out std_logic

		);
	end component;

	signal help,grater,lower,equal : std_logic_vector(15 downto 0);
begin
	help <= X"0001";
	output<=help;
	firstStep: comprator port map('0','0','1',a(15),b(15),grater(15),lower(15),equal(15));
	second_step : for i in 1 to 15 generate
		ey_baba: comprator port map(grater(16-i),lower(16-i),equal(16-i),a(15-i),b(15-i),grater(15-i),lower(15-i),equal(15-i));
	end generate second_step;
	eq<=equal(0);
	gr<=grater(0);
	lo<=lower(0);
end;
	
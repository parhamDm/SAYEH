library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
	port(
		Rd     : in  std_logic_vector(15 downto 0);
		result : out std_logic_vector(15 downto 0)
	);
end entity multiplier;

architecture RTL of multiplier is
	component andOp is
		port(
			Op     : in  std_logic;
			DataIn : in  std_logic_vector(7 downto 0);
			outPut : out std_logic_vector(7 downto 0)
		);
	end component;
	type arrayOfNums is array (0 to 7) of std_logic_vector(7 downto 0);
	type arrayOfNums2 is array (0 to 7) of std_logic_vector(15 downto 0);
	signal f, s  : std_logic_vector(7 downto 0);
	signal nums  : arrayOfNums;
	signal numss : arrayOfNums2;

begin
	f        <= Rd(15 downto 8);
	s        <= Rd(7 downto 0);
	la : for i in 0 to 7 generate
		lab : andOp
			port map(
				Op     => RD(i),
				DataIn => Rd(15 downto 8),
				outPut => nums(i)
			);
	end generate;
	numss(0) <= ("00000000" & nums(0) & "");
	numss(1) <= ("0000000" & nums(1) & "0");
	numss(2) <= ("000000" & nums(2) & "00");
	numss(3) <= ("00000" & nums(3) & "000");
	numss(4) <= ("0000" & nums(4) & "0000");
	numss(5) <= ("000" & nums(5) & "00000");
	numss(6) <= ("00" & nums(6) & "000000");
	numss(7) <= ("0" & nums(7) & "0000000");
	result <= std_logic_vector(unsigned(numss(0)) + unsigned(numss(1)) + unsigned(numss(2)) + unsigned(numss(3)) + unsigned(numss(4)) + unsigned(numss(5)) + unsigned(numss(6)) + unsigned(numss(7)));

end architecture RTL;

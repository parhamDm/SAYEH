
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sixteen_bit_adder is
	generic (n: integer := 16);
	port(
		a,b : in std_logic_vector(n-1 downto 0);
		ci : in std_logic;
		so : out std_logic_vector(n-1 downto 0);
		co : out std_logic);
end sixteen_bit_adder;

architecture Behavioral of sixteen_bit_adder is
component full_adder is 
		port(
			x,y,ci : in  std_logic;
			s,co : out  std_logic
		);
	end component;
		signal carry : std_logic_vector (n downto 0);
begin
	carry (0) <= ci;
	co <= carry (16);
	label0: for i in 0 to n-1 generate
		label1: full_adder port map(x => a(i), y => b(i), ci => carry(i), s => so(i), co => carry(i+1));
	end generate label0;
end Behavioral;


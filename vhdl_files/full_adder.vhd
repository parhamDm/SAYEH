
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full_adder is
	port(
		x,y,ci : in  std_logic;
		s,co : out  std_logic);
end full_adder;

architecture Behavioral of full_adder is

begin
		s <=x xor y xor ci;
		co <= (x and y) or (x and ci) or(y and ci);

end Behavioral;

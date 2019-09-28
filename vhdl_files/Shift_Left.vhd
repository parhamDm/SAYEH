library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shift_Left is
	port(
		RS      : in  std_logic_vector(15 downto 0);
		out_put : out std_logic_vector(15 downto 0)
	);
end entity Shift_Left;

architecture RTL of Shift_Left is
begin
	out_put <= (RS(14 downto 0) & "0");
end architecture RTL;


library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity flag_register is 
	port(
		c_in,z_in,clk,c_set,z_set,c_reset,z_reset,CAndZ_load:in std_logic;
		c_out,z_out:out std_logic:='0'
	);
end entity;

architecture behave of flag_register is 
	signal CS : std_logic_vector(4 downto 0);
begin
	CS<=(c_set & Z_set & c_reset & z_reset & CAndZ_load);
	process(clk)
	begin
		if clk'event and clk='1' then
			case CS is 
				when "10000" => C_out<='1';
				when "01000" => Z_out<='1';
				when "00100" => C_out<='0';
				when "00010" => Z_out<='0';
				when "00001" =>
					C_out<=c_in;
					Z_out<=z_in;
				when others=>
		  end case;
		 end if;
	end process;
end;
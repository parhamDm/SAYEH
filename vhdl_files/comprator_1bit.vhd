library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comprator is 
	port(
		g_in,l_in,e_in,a,b:in std_logic;
		g_out,l_out,e_out: out std_logic
	);
end entity comprator;

architecture behave of comprator is
begin

	process(a,b,g_in,l_in,e_in)
		begin
   	g_out<='0';
		e_out<='0';
		l_out<='0';
		if g_in='1' then
		g_out<='1';
		e_out<='0';
		l_out<='0';
		end if;
		if l_in='1' then
		g_out<='0';
		e_out<='0';
		l_out<='1';
		end if;
		if e_in='1' then
		g_out<=a and (not b);
		e_out<=a xnor b;
		l_out<= (not a) and b;
		end if;
		end process;
end;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_6x64 is 
	port(
		select_in:in std_logic_vector(5 downto 0);
		enable:in std_logic;
		output:out std_logic_vector(63 downto 0)
		);
end entity;

architecture behave of decoder_6x64 is
	component Decoder_3x8 IS
		PORT (
			a : IN std_logic_vector(2 DOWNTO 0);
			e : IN std_logic;
			y : OUT std_logic_vector(7 DOWNTO 0)
		);
	END component Decoder_3x8;
	signal outFromFirst: std_logic_vector(7 downto 0);
begin
	firstdec: decoder_3x8 port map(select_in(5 downto 3),enable,outFromFirst);
	looper:for i in 0 to 7 generate
		l: decoder_3x8 port map(select_in(2 downto 0),outFromFirst(i),output(8*(i+1)-1 downto 8*i));
	end generate;
end;
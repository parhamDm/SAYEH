library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY Decoder_3x8 IS
	PORT (
		a : IN std_logic_vector(2 DOWNTO 0);
		e : IN std_logic;
		y : OUT std_logic_vector(7 DOWNTO 0)
	);
END ENTITY Decoder_3x8;

--
ARCHITECTURE RTL OF Decoder_3x8 IS
BEGIN
	PROCESS (e, a)
	BEGIN
		y<="00000000";
		IF e = '1' THEN
			IF a = "000" THEN
				y <= "00000001";
			ELSIF a = "001" THEN
				y <= "00000010";
			ELSIF a = "010" THEN
				y <= "00000100";
			ELSIF a = "011" THEN
				y <= "00001000";
			ELSIF a = "100" THEN
				y <= "00010000";
			ELSIF a = "101" THEN
				y <= "00100000";
			ELSIF a = "110" THEN
				y <= "01000000";
			ELSIF a = "111" THEN
				y <= "10000000";
			ELSE 
				y <= "00000000";
			END IF;
		end if;
		END PROCESS ;
END ARCHITECTURE RTL;
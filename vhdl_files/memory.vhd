--------------------------------------------------------------------------------
-- Author:        Parham Alvani (parham.alvani@gmail.com)
--
-- Create Date:   16-03-2017
-- Module Name:   memory.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
	generic(blocksize : integer := 1024);

	port(clk, readmem, writemem : in    std_logic;
	     addressbus             : in    std_logic_vector(15 downto 0);
	     databus                : inout std_logic_vector(15 downto 0);
	     memdataready           : out   std_logic);
end entity memory;

architecture behavioral of memory is
	type mem is array (0 to blocksize - 1) of std_logic_vector(15 downto 0);
begin
	process(clk)
		variable buffermem : mem     := (others => (others => '0'));
		variable ad        : integer;
		variable init      : boolean := true;
	begin
		if init = true then
 buffermem(0) := "0000000000000110";
      
      -- awp
      buffermem(1) := X"F4FF";
      
      -- mil r0, 01011101
      buffermem(2) := X"F0FF";
      buffermem(259):=X"AAA1";
      -- mih r0, 00000101
      buffermem(3) := X"00C1";
      buffermem(4) := X"0AFF";

			init         := false;
		end if;

		memdataready <= '0';

		if clk'event and clk = '1' then
			ad := to_integer(unsigned(addressbus));

			if readmem = '1' then       -- Readiing :)
				memdataready <= '1';
				if ad >= blocksize then
					databus <= (others => 'Z');
				else
					databus <= buffermem(ad);
				end if;
			elsif writemem = '1' then   -- Writing :)
				memdataready <= '1';
				if ad < blocksize then
					buffermem(ad) := databus;
				end if;
			elsif readmem = '0' then
				databus <= (others => 'Z');
			end if;
		end if;
	end process;
end architecture behavioral;

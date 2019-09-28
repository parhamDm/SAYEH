

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sayeh_and_ram is
	port(
		clk : in std_logic;
		rst : in std_logic
	);
end entity sayeh_and_ram;

architecture RTL of sayeh_and_ram is
	component SAYEH_PROCESSOR is
		port(
			clk, external_reset : in    std_logic;
			dataBus             : inout std_logic_vector(15 downto 0);
			readMem, writemem   : out   std_logic;
			AUout               : out   std_logic_vector(15 downto 0)
		);
	end component SAYEH_PROCESSOR;
	component memory is
		generic(blocksize : integer := 1024);

		port(clk, readmem, writemem : in    std_logic;
		     addressbus             : in    std_logic_vector(15 downto 0);
		     databus                : inout std_logic_vector(15 downto 0);
		     memdataready           : out   std_logic);
	end component memory;
	signal readmem,writemem:std_logic;
	signal AUout,dataBus: std_logic_vector(15 downto 0);
begin
	s:SAYEH_PROCESSOR
		port map(
			clk            => clk,
			external_reset => '1',
			dataBus        => dataBus,
			readMem        => readMem,
			writemem       => writemem,
			AUout          => AUout
		);
	mem:memory
		port map(
			clk          => clk,
			readmem      => readmem,
			writemem     => writemem,
			addressbus   => AUout,
			databus      => databus
		);
end architecture RTL;


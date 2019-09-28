
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity flag_register_tb is
end;

architecture bench of flag_register_tb is

  component flag_register 
  	port(
  		c_in,z_in,clk,c_set,z_set,c_reset,z_reset,CAndZ_load:in std_logic;
  		c_out,z_out:out std_logic
  	);
  end component;

  signal c_in,z_in,clk,c_set,z_set,c_reset,z_reset,CAndZ_load: std_logic;
  signal c_out,z_out: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: flag_register port map ( c_in       => c_in,
                                z_in       => z_in,
                                clk        => clk,
                                c_set      => c_set,
                                z_set      => z_set,
                                c_reset    => c_reset,
                                z_reset    => z_reset,
                                CAndZ_load => CAndZ_load,
                                c_out      => c_out,
                                z_out      => z_out );

  stimulus: process
  begin
  
    -- Put initialisation code here
	c_in<='1';
	z_in<='0';
	c_set<='1';
	z_set<='1';
	c_reset<='0';
	z_reset<='0';

    -- Put test bench stimulus code here
	wait for 100000ns;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
  
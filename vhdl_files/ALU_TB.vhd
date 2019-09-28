-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity arithmatic_logic_unit_tb is
	  	GENERIC (n : INTEGER := 16);
end;

architecture bench of arithmatic_logic_unit_tb is

  component arithmatic_logic_unit
  	GENERIC (n : INTEGER := 16);
  	PORT (
  		RD, RS : IN std_logic_vector(n - 1 DOWNTO 0);
  		select_op : IN std_logic_vector(n-1 DOWNTO 0);
  		zero_in, carry_in : IN std_logic;
  		ALU_OUT : OUT std_logic_vector(n - 1 DOWNTO 0);
  		zero_out, carry_out : OUT std_logic
  	);
  end component;

  signal RD, RS: std_logic_vector(n - 1 DOWNTO 0);
  signal select_op: std_logic_vector(n-1 DOWNTO 0);
  signal zero_in, carry_in: std_logic;
  signal ALU_OUT: std_logic_vector(n - 1 DOWNTO 0);
  signal zero_out, carry_out: std_logic ;
	signal bb,aa:std_logic_vector(15 downto 0);
	
begin

  -- Insert values for generic parameters !!
  uut: arithmatic_logic_unit 
                                port map ( RD        => RD,
                                           RS        => RS,
                                           select_op => select_op,
                                           zero_in   => zero_in,
                                           carry_in  => carry_in,
                                           ALU_OUT   => ALU_OUT,
                                           zero_out  => zero_out,
                                           carry_out => carry_out );

  stimulus: process
  begin
    bb<="1111111100000000";
	aa<="0000000011111111";
	RD(15 downto 8)<="00000000";
	RD(7 downto 0)<=bb(7 downto 0);
	RS<="1010101010100000";
	
	zero_in<='0';
	carry_in<='0';
	select_op<="0100000000000000";

    wait;
  end process;


end;
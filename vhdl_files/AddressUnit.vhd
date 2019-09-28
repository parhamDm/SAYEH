library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AddressUnit is 
	port(
		Rside: in std_logic_vector(15 downto 0);
		Iside: in std_logic_vector(7 downto 0);
		Address : out std_logic_vector(15 downto 0);
		clk,ResetPc,PCplusI,PCplus1 : IN std_logic;
		RplusI, Rplus0,EnablePC: in std_logic
	);
end entity;

architecture dataflow of AddressUnit is
	component ProgramCounter is
		port(
			EnablePc : IN std_logic;
			input : IN std_logic_vector(15 downto 0);
			clk : IN std_logic;
			output: out std_logic_vector(15 downto 0)
		);
	end component;
	component addressLogic IS
		PORT (
			PCside, Rside : IN std_logic_vector (15 DOWNTO 0);
			Iside : IN std_logic_vector (7 DOWNTO 0);
			ALout : OUT std_logic_vector (15 DOWNTO 0);
			ResetPC, PCplusI, PCplus1, RplusI, Rplus0 : IN std_logic
		);
	END component;
	signal pcout : std_logic_vector(15 downto 0);
	signal AddressSignal : std_logic_vector(15 downto 0);
begin
		Address<=addressSignal;
		l1:ProgramCounter port map (EnablePC,AddressSignal,clk,pcout);
		l2: addressLogic port map 
			(pcout,Rside,Iside,AddressSignal,ResetPC,PCplusI,PCplus1,RplusI,Rplus0);
end architecture;			
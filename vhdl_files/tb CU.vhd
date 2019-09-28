library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Control_Unit_tb is
end;

architecture bench of Control_Unit_tb is

  component Control_Unit
  	port(
  		instructions: in std_logic_vector(15 downto 0);
  		clk,carry_flag,zero_flag : in std_logic;
  		Address_on_Databus,readMem,writemem,Ram_to_bus,RFHwrite,RFLwrite,
  		RFright_ON_OpandBus,IR_on_LopandBus,IR_on_HopandBus,IRLoad
  		,Memory_on_DataBus,ALUonDataBus,WP_clr,WP_ADD: out std_logic;
  		flag_inputs,AL_inputs : out std_logic_vector(4 downto 0);
  		ALU_ins: out std_logic_vector(15 downto 0)
  	);
  end component;

  signal instructions: std_logic_vector(15 downto 0);
  signal clk,carry_flag,zero_flag: std_logic;
  signal Address_on_Databus,readMem,writemem,Ram_to_bus,RFHwrite,RFLwrite, RFright_ON_OpandBus,IR_on_LopandBus,IR_on_HopandBus,IRLoad ,Memory_on_DataBus,ALUonDataBus,WP_clr,WP_ADD: std_logic;
  signal flag_inputs,AL_inputs: std_logic_vector(4 downto 0);
  signal ALU_ins: std_logic_vector(15 downto 0);

  constant clock_period: time := 200 ns;
  signal stop_the_clock: boolean;

begin

  uut: Control_Unit port map ( instructions        => instructions,
                               clk                 => clk,
                               carry_flag          => carry_flag,
                               zero_flag           => zero_flag,
                               Address_on_Databus  => Address_on_Databus,
                               readMem             => readMem,
                               writemem            => writemem,
                               Ram_to_bus          => Ram_to_bus,
                               RFHwrite            => RFHwrite,
                               RFLwrite            => RFLwrite,
                               RFright_ON_OpandBus => RFright_ON_OpandBus,
                               IR_on_LopandBus     => IR_on_LopandBus,
                               IR_on_HopandBus     => IR_on_HopandBus,
                               IRLoad              => IRLoad,
                               Memory_on_DataBus   => Memory_on_DataBus,
                               ALUonDataBus        => ALUonDataBus,
                               WP_clr              => WP_clr,
                               WP_ADD              => WP_ADD,
                               flag_inputs         => flag_inputs,
                               AL_inputs           => AL_inputs,
                               ALU_ins             => ALU_ins );

  stimulus: process
  begin
  
    -- Put initialisation code here
  instructions<="0000000000000011";
    -- Put test bench stimulus code here
	wait for 10000ns;
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
  
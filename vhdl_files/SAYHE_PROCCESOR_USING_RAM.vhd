library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity SAYEH_PROCESSOR is
	port(
		clk,external_reset               : in    std_logic;
		dataBus           : inout std_logic_vector(15 downto 0);
		readMem, writemem : out   std_logic;
		AUout             : out   std_logic_vector(15 downto 0)
	);
end entity SAYEH_PROCESSOR;

architecture behave of SAYEH_PROCESSOR is
	component DataPass is
		port(
			DataBus                                                                                                                                                                                                         : inout std_logic_vector(15 downto 0);
			IRout, AUout                                                                                                                                                                                                    : out   std_logic_vector(15 downto 0);
			clk                                                                                                                                                                                                             : in    std_logic;
			carry_flag, zero_flag                                                                                                                                                                                           : out   std_logic;
			Address_on_Databus, Ram_to_bus, RFHwrite, RFLwrite, RFright_ON_OpandBus, IR_on_LopandBus, IR_on_HopandBus, IRLoad, EnablePC, ALUonDataBus, WP_clr, WP_ADD, Rd_on_AdressUnitRSide, Rs_on_AdressUnitRSide, shadow : in    std_logic;
			flag_inputs, AL_inputs                                                                                                                                                                                          : in    std_logic_vector(4 downto 0);
			ALU_ins                                                                                                                                                                                                         : in    std_logic_vector(15 downto 0)
		);
	end component DataPass;

	component Control_Unit is
		port(
			instructions                                                                                                                                                                                                                           : in  std_logic_vector(15 downto 0);
			clk, carry_flag, zero_flag                                                                                                                                                                                                             : in  std_logic;
			Address_on_Databus, Ram_to_bus, RFHwrite, RFLwrite, RFright_ON_OpandBus, IR_on_LopandBus, IR_on_HopandBus, IRLoad, Memory_on_DataBus, EnablePC, ALUonDataBus, WP_clr, WP_ADD, Rd_on_AdressUnitRSide, Rs_on_AdressUnitRSide, shadow_out : out std_logic;
			flag_inputs, AL_inputs                                                                                                                                                                                                                 : out std_logic_vector(4 downto 0);
			ALU_ins                                                                                                                                                                                                                                : out std_logic_vector(15 downto 0);
			readMem, writemem                                                                                                                                                                                                                      : out std_logic
		);
	end component;

	component memory is
		generic(blocksize : integer := 1024);

		port(clk, readmem, writemem : in    std_logic;
		     addressbus             : in    std_logic_vector(15 downto 0);
		     databus                : inout std_logic_vector(15 downto 0);
		     memdataready           : out   std_logic);
	end component memory;
	signal instructions, IRout                                                                                                                                                                                                                          : std_logic_vector(15 downto 0);
	signal carry_flag, zero_flag                                                                                                                                                                                                                        : std_logic;
	signal Address_on_Databus, Ram_to_bus, RFHwrite, RFLwrite, RFright_ON_OpandBus, IR_on_LopandBus, IR_on_HopandBus, IRLoad, Memory_on_DataBus, EnablePC, ALUonDataBus, WP_clr, WP_ADD, Rd_on_AdressUnitRSide, Rs_on_AdressUnitRSide, shadow_out : std_logic;
	signal flag_inputs, AL_inputs                                                                                                                                                                                                                       : std_logic_vector(4 downto 0);
	signal ALU_ins                                                                                                                                                                                                                                      : std_logic_vector(15 downto 0);
	signal inout_connector                                                                                                                                                                                                                              : std_logic_vector(15 downto 0);
begin
	d : DataPass
		port map(DataBus, IRout, AUout, clk, carry_flag, zero_flag, Address_on_Databus, Ram_to_bus, RFHwrite, RFLwrite, RFright_ON_OpandBus, IR_on_LopandBus, IR_on_HopandBus, IRLoad, EnablePC,
		         ALUonDataBus, WP_clr, wp_add, Rd_on_AdressUnitRSide, Rs_on_AdressUnitRSide,
		         shadow_out, flag_inputs, AL_inputs, ALU_ins);
	uut : Control_Unit
		port map(instructions          => IRout,
		         clk                   => clk,
		         carry_flag            => carry_flag,
		         zero_flag             => zero_flag,
		         Address_on_Databus    => Address_on_Databus,
		         Ram_to_bus            => Ram_to_bus,
		         RFHwrite              => RFHwrite,
		         RFLwrite              => RFLwrite,
		         RFright_ON_OpandBus   => RFright_ON_OpandBus,
		         IR_on_LopandBus       => IR_on_LopandBus,
		         IR_on_HopandBus       => IR_on_HopandBus,
		         IRLoad                => IRLoad,
		         Memory_on_DataBus     => Memory_on_DataBus,
		         EnablePC              => EnablePC,
		         ALUonDataBus          => ALUonDataBus,
		         WP_clr                => WP_clr,
		         WP_ADD                => WP_ADD,
		         Rd_on_AdressUnitRSide => Rd_on_AdressUnitRSide,
		         Rs_on_AdressUnitRSide => Rs_on_AdressUnitRSide,
		         shadow_out            => shadow_out,
		         flag_inputs           => flag_inputs,
		         AL_inputs             => AL_inputs,
		         ALU_ins               => ALU_ins,
		         readMem               => readMem,
		         writemem              => writemem);
end;

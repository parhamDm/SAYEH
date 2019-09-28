library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataPass is
	port(
		DataBus                                                                                                                                                                                                         : inout std_logic_vector(15 downto 0);
		IRout, AUOut                                                                                                                                                                                                    : out   std_logic_vector(15 downto 0);
		clk                                                                                                                                                                                                             : in    std_logic;
		carry_flag, zero_flag                                                                                                                                                                                           : out   std_logic;
		Address_on_Databus, Ram_to_bus, RFHwrite, RFLwrite, RFright_ON_OpandBus, IR_on_LopandBus, IR_on_HopandBus, IRLoad, EnablePC, ALUonDataBus, WP_clr, WP_ADD, Rd_on_AdressUnitRSide, Rs_on_AdressUnitRSide, shadow : in    std_logic;
		flag_inputs, AL_inputs                                                                                                                                                                                          : in    std_logic_vector(4 downto 0);
		ALU_ins                                                                                                                                                                                                         : in    std_logic_vector(15 downto 0)
	);
end entity DataPass;

architecture behave of DataPass is
	component AddressUnit is
		port(
			Rside                          : in  std_logic_vector(15 downto 0);
			Iside                          : in  std_logic_vector(7 downto 0);
			Address                        : out std_logic_vector(15 downto 0);
			clk, ResetPc, PCplusI, PCplus1 : IN  std_logic;
			RplusI, Rplus0, EnablePC       : in  std_logic
		);
	end component;
	component Instruction_Register is
		port(
			DataIn    : in  std_logic_vector(15 downto 0);
			clk, load : in  std_logic;
			DataOut   : out std_logic_vector(15 downto 0)
		);
	end component;

	component register_file IS
		PORT(
			DataIn                                : IN  std_logic_vector(15 DOWNTO 0);
			selectHight, selectLow, clk, resetAll : IN  std_logic;
			WindowPointer                         : IN  std_logic_vector(5 DOWNTO 0);
			instructoin                           : IN  std_logic_vector(3 DOWNTO 0);
			RS, RD                                : OUT std_logic_vector(15 DOWNTO 0)
		);
	END component;

	component arithmatic_logic_unit IS
		GENERIC(n : INTEGER := 16);
		PORT(
			RD, RS              : IN  std_logic_vector(n - 1 DOWNTO 0);
			select_op           : IN  std_logic_vector(n - 1 DOWNTO 0);
			zero_in, carry_in   : IN  std_logic;
			ALU_OUT             : OUT std_logic_vector(n - 1 DOWNTO 0);
			zero_out, carry_out : OUT std_logic
		);
	END component;

	component Window_Pointer is
		port(
			clk, reset, load_sum : in  std_logic;
			dataLoadIn           : in  std_logic_vector(5 downto 0);
			DataOut              : out std_logic_vector(5 downto 0)
		);
	end component;
	component flag_register is
		port(
			c_in, z_in, clk, c_set, z_set, c_reset, z_reset, CAndZ_load : in  std_logic;
			c_out, z_out                                                : out std_logic
		);
	end component;
	signal zero_in, zero_out, carry_in, carry_out              : std_logic;
	signal WP_out                                              : std_logic_vector(5 downto 0);
	signal IR_out_to_RF                                        : std_logic_vector(3 downto 0);
	signal RS, RD, OpndBus, AU_Rside, address, ALU_out, IR_out : std_logic_vector(15 downto 0);
	signal AU_PCside                                           : std_logic_vector(7 downto 0);
begin
	AUcomponents : AddressUnit
		port map(AU_Rside, AU_PCside, Address, clk,
		         AL_inputs(0), AL_inputs(1), AL_inputs(2),
		         AL_inputs(3), AL_inputs(4), EnablePC
		);

	RFcomponentes : register_file port map(DataBus, RFHwrite, RFLwrite, clk, '0', WP_out, IR_out_to_RF, RS, RD);
	ALUComponents : arithmatic_logic_unit
		port map(RD, OpndBus, ALU_ins,
		         zero_out, carry_out, ALU_OUT, zero_in, carry_in
		);

	FRconfig : flag_register
		port map(
			carry_in, zero_in, clk, flag_inputs(4), flag_inputs(3), flag_inputs(2),
			flag_inputs(1), flag_inputs(0), carry_out,zero_out
		);

	irConfig : Instruction_Register port map(DataBus, clk, IRLoad, IR_out);
	WPCOnfig : Window_Pointer port map(clk, WP_clr, WP_add, IR_out(5 downto 0), WP_out);
	AU_Rside <= RD when Rd_on_AdressUnitRSide = '1'
		else RS when Rs_on_AdressUnitRSide = '1'
		else (others => 'Z');
	OpndBus(7 downto 0)  <= IR_out(7 downto 0) when IR_on_LopandBus='1' else (others=>'Z');
	OpndBus(15 downto 0)  <= (IR_out(7 downto 0)&"00000000") when IR_on_HopandBus='1' else (others=>'Z');
	OpndBus<=RS when RFright_ON_OpandBus='1' else (others=>'Z');

	IR_out_to_RF <= IR_out(11 downto 8) when shadow = '1'
		else IR_out(3 downto 0) when shadow = '0'
	;
	IRout        <= ir_out;
	DataBus      <= ALU_OUT when ALUonDataBus = '1'
		else Address when Address_on_Databus = '1'
		else (others => 'Z');
	zero_flag    <= zero_out;
	carry_flag   <= carry_out;
	AUOut        <= address;
	AU_PCside    <= IR_out(7 downto 0);
end;

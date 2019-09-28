LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY register_file IS
	PORT (
		DataIn : IN std_logic_vector(15 DOWNTO 0);
		selectHight, selectLow, clk, resetAll : IN std_logic;
		WindowPointer : IN std_logic_vector(5 DOWNTO 0);
		instructoin : IN std_logic_vector(3 DOWNTO 0);
		RS, RD : OUT std_logic_vector(15 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE behave OF register_file IS
	COMPONENT register16bit IS
		PORT (
			DataIn : IN std_logic_vector(15 DOWNTO 0);
			highLoad, lowLoad, reset, clk : IN std_logic;
			DataOut : OUT std_logic_vector(15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT decoder_6x64 IS
		PORT (
			select_in : IN std_logic_vector(5 DOWNTO 0);
			enable : IN std_logic;
			output : OUT std_logic_vector(63 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT sixteen_bit_adder IS
		GENERIC (n : INTEGER := 16);
		PORT (
			a, b : IN std_logic_vector(n - 1 DOWNTO 0);
			ci : IN std_logic;
			so : OUT std_logic_vector(n - 1 DOWNTO 0);
			co : OUT std_logic
		);
	END COMPONENT sixteen_bit_adder;
 
	COMPONENT trie_state_buffer_16bit IS
		PORT (
			control : IN std_logic;
			input : IN std_logic_vector(15 DOWNTO 0);
			output : OUT std_logic_vector(15 DOWNTO 0)
		);
	END COMPONENT trie_state_buffer_16bit;
	TYPE outputGenerator IS ARRAY (0 TO 63) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ADO_0, ADO_1, ADO_2, ADO_3 : std_logic_vector(63 DOWNTO 0);
	SIGNAL toTriState : outputGenerator;
	SIGNAL WindowPointerTo16Bit, instructionTo16Bit_RS, instructionTo16Bit_RD, SumRd, SumRs : std_logic_vector(15 DOWNTO 0);
	SIGNAL selectRS, selectRD : std_logic_vector(5 DOWNTO 0);
	SIGNAL carries : std_logic_vector(1 DOWNTO 0);
BEGIN

	--generating decodders of input;
	HighValueDecoder: decoder_6x64 port map(selectRD,selectHight,ADO_0);
	LowValueDecoder : decoder_6x64 port map(selectRD,selectLow,ADO_1);
	ChooseRD: decoder_6x64 port map(selectRD,'1',ADO_2);
	chooseRS: decoder_6x64 port map(selectRS,'1',ADO_3);
	--generating sum of adresses
	WindowPointerTo16Bit<= "0000000000" & WindowPointer;
	instructionTo16Bit_RD<= "00000000000000" & instructoin(3 downto 2);
	instructionTo16Bit_RS<= "00000000000000" & instructoin(1 downto 0);
	RDSumGenerator: sixteen_bit_adder port map(instructionTo16Bit_RD,WindowPointerTo16Bit,'0',sumRD,carries(0));
	RSSumGenerator: sixteen_bit_adder port map(instructionTo16Bit_RS,WindowPointerTo16Bit,'0',sumRS,carries(1));
	selectRS<=sumRS(5 downto 0);
	selectRD<=sumRD(5 downto 0);
	--connecting everything
	labe: for i in 0 to 63 generate
		reg: register16bit port map(DataIn,ADO_0(i),ADO_1(i),resetAll,clk,toTriState(i));
	end generate;
	labee: for i in 0 to 63 generate 
		tri0: trie_state_buffer_16bit port map(ADO_2(i),toTriState(i),RD);
		tri1: trie_state_buffer_16bit port map(ADo_3(i),toTriState(i),RS);
	end generate;
end;
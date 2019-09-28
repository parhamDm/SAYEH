LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY arithmatic_logic_unit IS
	GENERIC(n : INTEGER := 16);
	PORT(
		RD, RS              : IN  std_logic_vector(n - 1 DOWNTO 0);
		select_op           : IN  std_logic_vector(n - 1 DOWNTO 0);
		zero_in, carry_in   : IN  std_logic;
		ALU_OUT             : OUT std_logic_vector(n - 1 DOWNTO 0);
		zero_out, carry_out : OUT std_logic
	);
END ENTITY;

ARCHITECTURE behave of arithmatic_logic_unit IS
	component Shift_Left is
		port(
			RS      : in  std_logic_vector(15 downto 0);
			out_put : out std_logic_vector(15 downto 0)
		);
	end component Shift_Left;
	COMPONENT trie_state_buffer_16bit IS
		PORT(
			control : IN  std_logic;
			input   : IN  std_logic_vector(15 DOWNTO 0);
			output  : OUT std_logic_vector(15 DOWNTO 0)
		);
	END COMPONENT trie_state_buffer_16bit;
	COMPONENT comparaor_16bit IS
		PORT(
			a, b       : IN  std_logic_vector(15 DOWNTO 0);
			eq, lo, gr : OUT std_logic;
			output     : out std_logic_vector(15 downto 0)
		);
	END COMPONENT comparaor_16bit;
	COMPONENT shift_right_comp IS
		PORT(
			Rs     : IN  std_logic_vector(15 DOWNTO 0);
			output : OUT std_logic_vector(15 DOWNTO 0);
			carry  : OUT std_logic
		);
	END COMPONENT shift_right_comp;
	COMPONENT or_comp IS
		PORT(
			Rs, Rd : IN  std_logic_vector(15 DOWNTO 0);
			output : OUT std_logic_vector(15 DOWNTO 0)
		);
	END COMPONENT or_comp;
	COMPONENT and_comp IS
		PORT(
			Rs, Rd : IN  std_logic_vector(15 DOWNTO 0);
			output : OUT std_logic_vector(15 DOWNTO 0)
		);

	END COMPONENT and_comp;
	component sixteen_bit_adder is
		generic(n : integer := 16);
		port(
			a, b : in  std_logic_vector(n - 1 downto 0);
			ci   : in  std_logic;
			so   : out std_logic_vector(n - 1 downto 0);
			co   : out std_logic);
	end component sixteen_bit_adder;

	component not_gate is
		port(
			RS     : in    std_logic_vector(15 downto 0);
			not_Rs : inout std_logic_vector(15 downto 0)
		);
	end component;

	type array_type is array (0 to 10) of std_logic_vector(15 downto 0);
	signal to_tri                           : array_type;
	signal carries                          : std_logic_vector(10 downto 0);
	signal carryInGenerator                 : std_logic_vector(16 downto 0);
	signal isZero                           : std_logic_vector(1 downto 0);
	signal notRD                            : std_logic_vector(n-1 downto 0);
	signal notCarry, grearter, equal, lower : std_logic;
	signal TRI_OUT                          : std_logic_vector(n-1 downto 0);
	signal bout                             : std_logic;
BEGIN
	alu_out <= TRI_OUT;
	-- generate not RD and not carry
	la : for i in 0 to 15 generate
		notRD(i) <= (not RD(i));
	end generate;
	notCarry <= not carry_in;
	-- output is zero
	isZero(0) <= (not TRI_OUT(0)) and (not TRI_OUT(1)) and (not TRI_OUT(2)) and (not TRI_OUT(3)) and (not select_op(0)) ;
	isZero(1) <= (not TRI_OUT(4)) and (not TRI_OUT(5)) and (not TRI_OUT(6)) and (not TRI_OUT(7)) and (not TRI_OUT(8)) and (not TRI_OUT(9)) and (not TRI_OUT(10)) and (not TRI_OUT(11)) and (not TRI_OUT(12)) and (not TRI_OUT(13)) and (not TRI_OUT(14)) and (not TRI_OUT(15)) and (isZero(0));
	-- intualize or component
	or_toTri_State_B : or_comp port map(RS, RD, to_tri(0));
	trie_1_to_out : trie_state_buffer_16bit port map(select_op(7), to_tri(0), TRI_OUT);
	-- intualize and component
	AndCompToTrieStateBuffer : and_comp port map(RS, RD, to_tri(1));
	TriStateToOutPut0 : trie_state_buffer_16bit port map(select_op(6), to_tri(1), TRI_OUT);
	-- intualize sum component
	ADDComponentToTri : sixteen_bit_adder port map(RS, RD, carry_in, to_tri(2), carries(0));
	TriStateToOutPut1 : trie_state_buffer_16bit port map(select_op(11), to_tri(2), TRI_OUT);
	-- intualize subtracter base on Carry
	subComponentToTri0 : sixteen_bit_adder port map(RS, notRD, notCarry, to_tri(4), carries(1));
	subToTrie : trie_state_buffer_16bit port map(select_op(12), to_tri(4), TRI_OUT);
	-- intualize shift right component;
	Shiftright : shift_right_comp port map(RS, to_tri(3), carries(2));
	ShiftrightToTrie : trie_state_buffer_16bit port map(select_op(10), to_tri(3), TRI_OUT);
	-- comparaor 16 bit component
	comparaortoTrie : comparaor_16bit port map(RS, RD, equal, lower, grearter);
	-- Triecompare : trie_state_buffer_16bit port map(select_op(14), to_tri(6), TRI_OUT);
	-- not gate
	notComp : component not_gate
		port map(
			RS     => RS,
			not_Rs => to_tri(5)
		);
	notToTrie : component trie_state_buffer_16bit
		port map(
			control => select_op(8),
			input   => to_tri(5),
			output  => TRI_OUT
		);
	--shift Left
	slcomp : component Shift_Left
		port map(
			RS      => RS,
			out_put => to_tri(6)
		);
	sltotrie: component trie_state_buffer_16bit
		port map(
			control => select_op(9),
			input   => to_tri(6),
			output  => TRI_OUT
		);
	-- bout
	bout <= select_op(0) or select_op(1);
	RStotrie : trie_state_buffer_16bit port map(bout, RS, TRI_OUT);

	zero_out  <= (isZero(1) or (equal and select_op(14)));
	carry_out <= (carries(0) and select_op(11)) or (NOT carries(1) and select_op(12)) or (grearter and select_op(14));
end;

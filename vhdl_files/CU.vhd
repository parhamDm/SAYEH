library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Control_Unit is
	port(
		instructions                                                                                                                                                                                                                           : in  std_logic_vector(15 downto 0);
		clk, carry_flag, zero_flag                                                                                                                                                                                                             : in  std_logic;
		Address_on_Databus, Ram_to_bus, RFHwrite, RFLwrite, RFright_ON_OpandBus, IR_on_LopandBus, IR_on_HopandBus, IRLoad, Memory_on_DataBus, EnablePC, ALUonDataBus, WP_clr, WP_ADD, Rd_on_AdressUnitRSide, Rs_on_AdressUnitRSide, shadow_out : out std_logic;
		flag_inputs, AL_inputs                                                                                                                                                                                                                 : out std_logic_vector(4 downto 0);
		ALU_ins                                                                                                                                                                                                                                : out std_logic_vector(15 downto 0);
		readMem, writemem                                                                                                                                                                                                                      : out std_logic
	);
end entity;

architecture behave of Control_Unit is
	type statemachine is (init, readFromMem, instruction, closeAllGates, MoveImmd1, MoveImmd2, readyToReadMem, fetch, Decode, notSupportedYet, exec1, exec2, writeTomem, halt);

	signal shadow                                     : std_logic;
	signal CS                                         : statemachine;
	signal CI                                         : std_logic_vector(7 downto 0);
	signal CI_first_part, CI_Second_part, CI_Immdpart : integer;
begin
	CI             <= instructions(15 downto 8) when shadow = '1' else instructions(7 downto 0);
	CI_first_part  <= to_integer(unsigned(CI(7 downto 4)));
	CI_Second_part <= to_integer(unsigned(CI(3 downto 0)));
	CI_Immdpart    <= to_integer(unsigned(CI(1 downto 0)));
	process(clk)
	begin
		if clk'event and clk = '1' then
			flag_inputs           <= "00000";
			AL_inputs             <= "00000";
			RFHwrite              <= '0';
			RFLwrite              <= '0';
			ALUonDataBus          <= '0';
			RFHwrite              <= '0';
			IR_on_HopandBus       <= '0';
			IR_on_LopandBus       <= '0';
			Ram_to_bus            <= '0';
			EnablePC              <= '0';
			Address_on_Databus    <= '0';
			Ram_to_bus            <= '0';
			RFright_ON_OpandBus   <= '0';
			IRLoad                <= '0';
			Memory_on_DataBus     <= '0';
			WP_clr                <= '0';
			WP_ADD                <= '0';
			Rd_on_AdressUnitRSide <= '0';
			Rs_on_AdressUnitRSide <= '0';
			writemem              <= '0';
			readmem               <= '0';

			case CS is
				when halt =>
				when init => readmem <= '1';
					CS      <= readFromMem;
				when readFromMem =>
					shadow <= '1';
					IRLoad <= '1';
					CS     <= fetch;
				when fetch =>
					CS <= Decode;
				when Decode =>
					if (instructions = "UUUUUUUUUUUUUUUU") then
						CS <= readFromMem;
					else
						if CI_first_part = 0 then
							if CI_Second_part > 6 then
								CS <= MoveImmd1;
							else
								CS <= instruction;
							end if;
						elsif CI_first_part = 15 then
							CS <= MoveImmd2;
						else
							CS <= instruction;
						end if;
					end if;

				when instruction =>

					if CI_first_part = 0 then
						case CI_Second_part is
							when 0 =>
							when 1 =>
								CS <= notSupportedYet;
							when 2 =>
								flag_inputs <= "01000";
							when 3 =>
								flag_inputs <= "00010";
							when 4 =>
								flag_inputs <= "10000";
							when 5 =>
								flag_inputs <= "00100";
							when 6 =>
								WP_clr <= '1';
							when others =>
						end case;
						if (shadow = '0' or shadow = '-') then
							CS        <= readFromMem;
							AL_inputs <= "00100";
							EnablePC  <= '1';
							shadow    <= '1';
							readmem   <= '1';
						end if;
						if (shadow = '1') then
							CS     <= instruction;
							shadow <= '0';
						end if;
					end if;
					if CI_first_part = 1 then
						RFright_ON_OpandBus <= '1';
						ALU_ins             <= X"0001";
						RFLwrite            <= '1';
						RFHwrite            <= '1';
						ALUonDataBus        <= '1';
						CS                  <= readyToReadMem;
					end if;
					if CI_first_part = 2 then
						Rs_on_AdressUnitRSide <= '1';
						AL_inputs             <= "10000";
						readMem               <= '1';
						CS                    <= exec1;
					end if;
					if CI_first_part = 3 then
						ALUonDataBus          <= '1';
						RFright_ON_OpandBus   <= '1';
						CS                    <= readyToReadMem;
						Rd_on_AdressUnitRSide <= '1';
						AL_inputs             <= "10000";
						ALU_ins               <= X"0001";
						writemem              <= '1';
					end if;
					if CI_First_part > 5 then
						ALUonDataBus        <= '1';
						RFright_ON_OpandBus <= '1';
						RFLwrite            <= '1';
						RFHwrite            <= '1';
						flag_inputs         <= "00001";
						CS                  <= readyToReadMem;
						case CI_first_part is
							when 6  => ALU_ins <= X"0040";
							when 11 => ALU_ins <= X"0800";
							when 12 => ALU_ins <= X"1000";
							when 9  => ALU_ins <= X"0200";
							when 10 => ALU_ins <= X"0400";
							when 8  => ALU_ins <= X"0100";
							when 7  => ALU_ins <= X"0080";
							when 14 => ALU_ins <= X"4001";
								RFLwrite <= '0';
								RFHwrite <= '0';
							when others =>
						end case;

					end if;
				when MoveImmd1 =>
					case CI_Second_part is
						when 7 =>
							AL_inputs <= "00010";
							EnablePC  <= '1';
						when 8 =>
							if zero_flag = '1' then
								AL_inputs <= "00010";
							else
								AL_inputs <= "00100";
							END IF;
						when 9 =>
							if carry_flag = '1' then
								AL_inputs <= "00010";
							else
								AL_inputs <= "00100";
							END IF;
						when 10 =>
							AL_inputs <= "00100";

							WP_ADD <= '1';
						when others =>
					end case;
					EnablePC <= '1';
					readmem  <= '1';
					CS       <= readFromMem;
				when MoveImmd2 =>
					case CI_Immdpart is
						when 0 =>
							IR_on_LopandBus <= '1';
							ALUonDataBus    <= '1';
							RFLwrite        <= '1';
							ALU_ins         <= X"0001";
							CS              <= readyToReadMem;
						when 1 =>
							RFHwrite        <= '1';
							IR_on_HopandBus <= '1';
							ALUonDataBus    <= '1';
							CS              <= readyToReadMem;
							ALU_ins         <= X"0001";
						when 3 =>
							Rd_on_AdressUnitRSide <= '1';
							AL_inputs             <= "01000";
							EnablePC              <= '1';
							CS                    <= readFromMem;
							readMem               <= '1';
						when 2 =>
							AL_inputs          <= "00010";
							Address_on_Databus <= '1';
							RFHwrite           <= '1';
							RFLwrite           <= '1';
							CS                 <= readyToReadMem;

						when others =>
					end case;
				when readyToReadMem =>
					if (CI_first_part = 15) then
						EnablePC  <= '1';
						readmem   <= '1';
						AL_inputs <= "00100";
						CS        <= readFromMem;
						shadow    <= '1';
					else
						if (shadow = '0' or shadow = '-') then
							CS        <= readFromMem;
							AL_inputs <= "00100";
							EnablePC  <= '1';
							readmem   <= '1';
						end if;
						if (shadow = '1') then
							shadow <= '0';
							CS     <= instruction;
						end if;
					end if;
				when exec1 =>
					Rs_on_AdressUnitRSide <= '1';
					AL_inputs             <= "10000";
					Cs                    <= readyToReadMem;
					RFLwrite              <= '1';
					RFHwrite              <= '1';
				when others => cs <= init;
			end case;
		end if;
	end process;
	shadow_out     <= shadow;
	process(clk) is
	begin
	end process;

end;

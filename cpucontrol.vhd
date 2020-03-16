library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL;

entity CPUControl is
-- Functionality should match the truth table shown in Figure 4.22 of the textbook, inlcuding the
--    output 'X' values.
-- The truth table in Figure 4.22 omits the jump instruction:
--    Jump = '1'
--    MemWrite = RegWrite = '0'
--    all other outputs = 'X'
port(Opcode   : in  STD_LOGIC_VECTOR(5 downto 0);
     RegDst   : out STD_LOGIC;
     Branch   : out STD_LOGIC;
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     Jump     : out STD_LOGIC;
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
);
end CPUControl;

architecture behavioral of CPUControl is
begin
	process(Opcode) is
	begin
		if(Opcode = "000000") then
			RegDst   <= '1';
			Branch   <= '0';
			MemRead  <= '0';
			MemtoReg <= '0';
			MemWrite <= '0';
			ALUSrc   <= '0';
			RegWrite <= '1';
			Jump     <= '0';
			ALUOp    <= "10";
		elsif(Opcode = "100011") then
			RegDst   <= '0';
			Branch   <= '0';
			MemRead  <= '1';
			MemtoReg <= '1';
			MemWrite <= '0';
			ALUSrc   <= '1';
			RegWrite <= '1';
			Jump     <= '0';
			ALUOp    <= "00";
		elsif(Opcode = "101011") then
			RegDst   <= 'X';
			Branch   <= '0';
			MemRead  <= '0';
			MemtoReg <= 'X';
			MemWrite <= '1';
			ALUSrc   <= '1';
			RegWrite <= '0';
			Jump     <= '0';
			ALUOp    <= "00";
		elsif(Opcode = "000100") then
			RegDst   <= 'X';
			Branch   <= '1';
			MemRead  <= '0';
			MemtoReg <= 'X';
			MemWrite <= '0';
			ALUSrc   <= '0';
			RegWrite <= '0';
			Jump     <= '0';
			ALUOp    <= "01";
		elsif(Opcode = "000010") then
			RegDst   <= 'X';
			Branch   <= 'X';
			MemRead  <= 'X';
			MemtoReg <= 'X';
			MemWrite <= '0';
			ALUSrc   <= 'X';
			RegWrite <= '0';
			Jump     <= '1';
			ALUOp    <= "XX";
		end if;
	end process;
end behavioral;

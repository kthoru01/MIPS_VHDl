library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUControl is
-- Functionality should match truth table shown in Figure 4.13 in the textbook.
-- You only need to consider the cases where ALUOp = "00", "01", and "10". ALUOp = "11" is not
--    a valid input and need not be considered; its output can be anything, including "0110",
--    "0010", "XXXX", etc.
-- To ensure proper functionality, you must implement the "don't-care" values in the funct field,
-- for example when ALUOp = '00", Operation must be "0010" regardless of what Funct is.
port(
     ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
     Funct     : in  STD_LOGIC_VECTOR(5 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
);
end ALUControl;

architecture behavioral of ALUControl is
begin

	process(ALUOp, Funct) is
	begin
		if (ALUOp = "00") then
			Operation <= "0010";
		elsif((ALUOp = "01")) then
			Operation <= "0110";
		elsif((ALUOp = "10") and (Funct(3 downto 0) = "0000")) then
			Operation <= "0010";
		elsif((ALUOp = "10") and (Funct(3 downto 0) = "0010")) then
			Operation <= "0110";
		elsif((ALUOp = "10") and (Funct(3 downto 0) = "0100")) then
			Operation <= "0000";
		elsif((ALUOp = "10") and (Funct(3 downto 0) = "0101")) then
			Operation <= "0001";
		elsif((ALUOp = "10") and (Funct(3 downto 0) = "1010")) then
			Operation <= "0111";
		else
			Operation <= "XXXX";
		end if;
	end process;
end behavioral;

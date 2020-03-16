library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- signed

entity ALU is
-- Implement: AND, OR, ADD (signed), SUBTRACT (signed)
--    as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the 'MIPS Reference Data' sheet at the
--    front of the textbook.
port(
     a         : in     STD_LOGIC_VECTOR(31 downto 0);
     b         : in     STD_LOGIC_VECTOR(31 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(31 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC
);
end ALU;

architecture behavioral of ALU is
begin

	process(a, b, operation) is
	begin

		if (operation = "0000") then -- AND
			result <= a and b;
			overflow <= '0';
			if ((a and b) = 32b"0") then
				zero <= '1';
			else
				zero <= '0';
			end if;
		elsif(operation = "0001") then -- OR
			result <= a or b;
			overflow <= '0';
			if ((a or b) = 32b"0") then
				zero <= '1';
			else
				zero <= '0';
			end if;
		elsif(operation = "0010") then -- add
			result <= std_logic_vector(signed(a) + signed(b));
			if (((signed(a) >= 0) and (signed(b) >= 0) and ((signed(a) + signed(b)) < 0)) or
			    ((signed(a) < 0) and (signed(b) < 0) and ((signed(a) + signed(b)) >= 0))) then
				overflow <= '1';
			else
				overflow <= '0';
			end if;
			if ((signed(a) + signed(b)) = 0) then
				zero <= '1';
			else
				zero <= '0';
			end if;
		elsif(operation = "0110") then -- substract
			result <= std_logic_vector(signed(a) - signed(b));
			if (((signed(a) >= 0) and (signed(b) < 0) and ((signed(a) - signed(b)) < 0)) or
			    ((signed(a) < 0) and (signed(b) >= 0) and ((signed(a) - signed(b)) >= 0))) then
				overflow <= '1';
			else
				overflow <= '0';
			end if;
			if ((signed(a) - signed(b)) = 0) then
				zero <= '1';
			else
				zero <= '0';
			end if;
		else
			result <= result;
			zero <= zero;
			overflow <= overflow;
		end if;
	end process;		
end behavioral;
			
			

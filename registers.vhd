library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity registers is
-- This component is described in the textbook, starting on page 2.52
-- The indices of each of the registers can be found on the MIPS reference page at the front of the
--    textbook
-- Keep in mind that register 0(zero) has a constant value of 0 and cannot be overwritten

-- This should only write on the negative edge of Clock when RegWrite is asserted.
-- Reads should be purely combinatorial, i.e. they don't depend on Clock
-- HINT: Use the provided dmem.vhd as a starting point
port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); -- address of register to be read
     RR2      : in  STD_LOGIC_VECTOR (4 downto 0); -- address of another register to be read
     WR       : in  STD_LOGIC_VECTOR (4 downto 0); -- address of the register to be written to
     WD       : in  STD_LOGIC_VECTOR (31 downto 0); -- data to write to register
     RegWrite : in  STD_LOGIC; -- flag to write the data
     Clock    : in  STD_LOGIC;
     RD1      : out STD_LOGIC_VECTOR (31 downto 0); -- data in register RR1
     RD2      : out STD_LOGIC_VECTOR (31 downto 0); -- data in register RR@
     --Probe ports used for testing
     -- $t0 & $t1 & t2 & t3
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0);
     -- $s0 & $s1 & s2 & s3
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0)
);
end registers;

architecture behavioral of registers is

type ByteArray is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0); -- 32 registers at 32 bits each
signal rgstr:ByteArray; -- registers array

begin
   process(WR, WD, RegWrite, Clock) -- Run when any of these inputs change
   variable addrW:integer; -- index to access registers array for writing
   variable first:boolean := true; -- Used for initialization

   -- registers $s0 to $s7 map onto registers 16 to 23
   -- registers $t0 to $t7 map onto registers 8 to 15, $t8 and $t9 map onto 24 and 25 respectfully
   -- registers $a0 to $a3 map onto registers 4 to 7
   -- register $sp and $ra map ontp registers 29 and 31 respectfully
   -- registers $v0 to $v1 map onto registers 2 and 3
   -- register $gp maps onto register 28
   -- register $fp maps onto register 30
   -- register $zero maps onto register 0

begin
      -- Initializing the registers as directed in MIPS reference page
      if(first) then
         rgstr(0)  <= 32b"0"; -- reg $zero
         rgstr(8)  <= 30b"0" & "01"; -- reg $t0 = 1
         rgstr(9)  <= 30b"0" & "10"; -- reg $t1 = 2
         rgstr(10) <= 29b"0" & "100"; -- reg $t2 = 4
         rgstr(11) <= 28b"0" & "1000"; -- reg $t3 = 8
         rgstr(16) <= 30b"0" & "01"; -- reg $s0 = 1
         rgstr(17) <= 30b"0" & "10"; -- reg $s1 = 2
         rgstr(18) <= 16b"0" & "1101111101111010"; -- reg $s2 = 234332205
         rgstr(19) <= 16b"0" & "1101111101111010"; -- reg $s3 = 234332205
         first := false; -- Don't initialize the next time this process runs
      end if;

      -- Writing to the register at address WR
      if (falling_edge(Clock) and (RegWrite = '1')) then
         addrW := to_integer(unsigned(WR));
         if ((addrW > 31) or (addrW < 2) or (addrW = 26) or (addrW = 27)) then
	     report "Invalid register addr. Attempted to write 4-bytes at address " &
             integer'image(addrW) & " but those registers are reserved or out of bounds" severity error;
         else
             rgstr(addrW) <= WD;
	 end if;
      end if;

end process;

process(RR1, RR2, rgstr)
variable addrR1:integer; -- index to access registers array to read 1st data
variable addrR2:integer; -- index to access registers array to read 2nd data

begin

      
      -- Reading from register at address RR1
      addrR1 := to_integer(unsigned(RR1));
      if ((addrR1 > 31) or (addrR1 < 0) or (addrR1 = 26) or (addrR1 = 27) or (addrR1 = 1)) then
         report "Invalid register addr. Attempted to read 4-bytes at address " &
         integer'image(addrR1) & " but those registers are reserved or out of bounds" severity error;
      else
         RD1 <= rgstr(addrR1); 
      end if;

      -- Reading from register at address RR2
      addrR2 := to_integer(unsigned(RR2));
      if ((addrR2 > 31) or (addrR2 < 0) or (addrR2 = 26) or (addrR2 = 27) or (addrR2 = 1)) then
         report "Invalid register addr. Attempted to read 4-bytes at address " &
         integer'image(addrR2) & " but those registers are reserved or out of bounds" severity error;
      else
         RD2 <= rgstr(addrR2); 
      end if;

      end process;

      DEBUG_TMP_REGS <= rgstr(8) & rgstr(9) & rgstr(10) & rgstr(11);
      DEBUG_SAVED_REGS <= rgstr(16) & rgstr(17) & rgstr(18) & rgstr(19);

end behavioral;
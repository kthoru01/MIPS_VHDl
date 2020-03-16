library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity IMEM is
-- The instruction memory is a byte addressable, big-endian, read-only memory
-- Reads occur continuously
-- HINT: Use the provided dmem.vhd as a starting point
generic(NUM_BYTES : integer := 128);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     Address  : in  STD_LOGIC_VECTOR(31 downto 0); -- Address to read from
     ReadData : out STD_LOGIC_VECTOR(31 downto 0)
);
end IMEM;

architecture behavioral of IMEM is

type ByteArray is array (0 to NUM_BYTES) of STD_LOGIC_VECTOR(7 downto 0);
signal insMem : ByteArray; -- memory array

begin
process(Address) is -- Run when Address changes
variable addr:integer; -- index used to access memory array
variable first:boolean := true; -- Used for initialization
	
    begin
	if(first) then
         -- MEM(0x0) = beq $s0 $s1 L1
         insMem(0)  <= "00010010";  
         insMem(1)  <= "00010001";  
         insMem(2)  <= "00000000";  
         insMem(3)  <= "00000011";
	 -- MEM(0x4) = add $t0 $t0 $t0
         insMem(4)  <= "00000001";  
         insMem(5)  <= "00001000";  
         insMem(6)  <= "01000000";  
         insMem(7)  <= "00100000";
	 -- MEM(0x8) = beq $s2 $s3 L2 
         insMem(8)   <= "00010010";  
         insMem(9)   <= "01010011";  
         insMem(10)  <= "00000000";  
         insMem(11)  <= "00000010";
	 -- MEM(0xC) = add $t1 $t1 $t1
         insMem(12)  <= "00000001";  
         insMem(13)  <= "00101001";  
         insMem(14)  <= "01001000";  
         insMem(15)  <= "00100000";
	 -- MEM(0x10) = add $t2 $t2 $t2
         insMem(16)  <= "00000001";  
         insMem(17)  <= "01001010";  
         insMem(18)  <= "01010000";  
         insMem(19)  <= "00100000";
	 -- MEM(0x14) = add $t3 $t3 $t3
         insMem(20)  <= "00000001";  
         insMem(21)  <= "01101011";  
         insMem(22)  <= "01011000";  
         insMem(23)  <= "00100000";
	 -- MEM(0x18) = jump exit
         insMem(24)  <= "00001000";  
         insMem(25)  <= "00000000";  
         insMem(26)  <= "00000000";  
         insMem(27)  <= "00001000";
	 -- MEM(0x1C) = add $s0 $s0 $s0
         insMem(28)  <= "00000010";  
         insMem(29)  <= "00010000";  
         insMem(30)  <= "10000000";  
         insMem(31)  <= "00100000";
	 -- MEM(0x20) = add $s1 $s1 $s1
         insMem(32)  <= "00000010";  
         insMem(33)  <= "00110001";  
         insMem(34)  <= "10001000";  
         insMem(35)  <= "00100000";
	 -- MEM(0x24) = nop
         insMem(36)  <= "00000000";  
         insMem(37)  <= "00000000";  
         insMem(38)  <= "00000000";  
         insMem(39)  <= "00000000";
	 -- MEM(0x28) = nop
         insMem(40)  <= "00000000";  
         insMem(41)  <= "00000000";  
         insMem(42)  <= "00000000";  
         insMem(43)  <= "00000000";
	 -- MEM(0x2C) = nop
         insMem(44)  <= "00000000";  
         insMem(45)  <= "00000000";  
         insMem(46)  <= "00000000";  
         insMem(47)  <= "00000000";
	 -- MEM(0x30) = nop
         insMem(48)  <= "00000000";  
         insMem(49)  <= "00000000";  
         insMem(50)  <= "00000000";  
         insMem(51)  <= "00000000";
         first := false; -- Don't initialize the next time this process runs
      end if;
	
	addr := to_integer(unsigned(Address));
	if (addr + 3 < NUM_BYTES) then -- Check that data is in the bounds of memory
		ReadData <= insMem(addr) & insMem(addr+1) & insMem(addr+2) & insMem(addr+3);
        else 
		report "Invalid DMEM addr. Attempted to read 4-bytes starting at address " &
            	integer'image(addr) & " but only " & integer'image(NUM_BYTES) & " bytes are available"
            	severity error;
	end if;
	end process;

end behavioral;

	
	




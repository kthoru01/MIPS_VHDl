library ieee;
use ieee.std_logic_1164.all;


-- 32-bit rising-edge triggered register with write-enable and asynchronous reset
entity IF_ID is
port (
        clk              : in std_logic; -- Propogate data in and out rising edge of clock
	reset            : in STD_LOGIC;
	ifFlush          : in STD_LOGIC;
        write_enable     : in STD_LOGIC;
        pcPlus4in        : in std_logic_vector(31 downto 0); -- next PC address 
        pcPlus4out       : out std_logic_vector(31 downto 0); -- current PC address 
	instructionIn    : in std_logic_vector(31 downto 0); -- next instrucion
        instructionOut   : out std_logic_vector(31 downto 0) -- current instruction
);
end IF_ID;

architecture behaviour of IF_ID is

begin
    
    process(clk, reset, ifFlush) begin
	if (reset) then
		pcPlus4Out <= 32b"0";
		instructionOut <= 32b"0";
	else
         	if rising_edge(clk) then
                     if (write_enable) then
			 if (ifFlush) then
                             instructionOut <= 32b"0";
                         else
	         	     instructionOut <= instructionIn;
			 end if;
                         pcPlus4out <= pcPlus4in;
                     else
                             pcPlus4out <= pcPlus4out;
                             instructionOut <= instructionOut;
                     end if;
	        end if;
         end if;
    end process;

end behaviour;

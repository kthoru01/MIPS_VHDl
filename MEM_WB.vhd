library ieee;
use ieee.std_logic_1164.all;


-- 32-bit rising-edge triggered register with write-enable and asynchronous reset
entity MEM_WB is
port (
	clk              : in STD_LOGIC;
	reset            : in STD_LOGIC;
	pcPlus4          : in STD_LOGIC_VECTOR(31 downto 0);
	pcPlus4Out        : out STD_LOGIC_VECTOR(31 downto 0);
        MemtoReg         : in STD_LOGIC;
	MemtoRegOut      : out STD_LOGIC;
	RegWrite         : in STD_LOGIC;
	RegWriteOut      : out STD_LOGIC;
	dmemData         : in std_logic_vector(31 downto 0);
        dmemDataOut      : out std_logic_vector(31 downto 0);
	ALUresult        : in std_logic_vector(31 downto 0);
	ALUresultOut     : out std_logic_vector(31 downto 0);
	DstReg           : in STD_LOGIC_VECTOR(4 downto 0);
	DstRegOut        : out STD_LOGIC_VECTOR(4 downto 0)
);
end MEM_WB;

architecture behaviour of MEM_WB is

begin
    
    process(clk) begin
	if (reset) then
		pcPlus4Out <= 32b"0";
		MemtoRegOut <= '0';
        	RegWriteOut <= '0';
		dmemDataOut <= 32b"0";
		ALUresultOut <= 32b"0";
		DstRegOut <= 5b"0";
	else
        	if rising_edge(clk) then
			pcPlus4Out <= pcPlus4;
        		MemtoRegOut <= MemtoReg;
        		RegWriteOut <= RegWrite;
			dmemDataOut <= dmemData;
			ALUresultOut <= ALUresult;
			DstRegOut <= DstReg;
       	 	end if;
	end if;
    end process;

end behaviour;

library ieee;
use ieee.std_logic_1164.all;


-- 32-bit rising-edge triggered register with write-enable and asynchronous reset
entity EX_MEM is
port (
	clk              : in STD_LOGIC;
	reset            : in STD_LOGIC;
	pcPlus4          : in STD_LOGIC_VECTOR(31 downto 0);
	pcPlus4Out       : out STD_LOGIC_VECTOR(31 downto 0);
        Branch           : in STD_LOGIC;
	BranchOut        : out STD_LOGIC;
        MemRead          : in STD_LOGIC;
	MemReadOut       : out STD_LOGIC;
        MemtoReg         : in STD_LOGIC;
	MemtoRegOut      : out STD_LOGIC;
        MemWrite         : in STD_LOGIC;
	MemWriteOut      : out STD_LOGIC;
	RegWrite         : in STD_LOGIC;
	RegWriteOut      : out STD_LOGIC;
        Jump             : in STD_LOGIC;
	JumpOut          : out STD_LOGIC;
	ALUresult        : in std_logic_vector(31 downto 0);
	ALUresultOut     : out std_logic_vector(31 downto 0);
	zero             : in STD_LOGIC;
	zeroOut          : out STD_LOGIC;
	RegData2         : in STD_LOGIC_VECTOR(31 downto 0);
	RegData2Out      : out STD_LOGIC_VECTOR(31 downto 0);
	DstReg           : in STD_LOGIC_VECTOR(4 downto 0);
	DstRegOut        : out STD_LOGIC_VECTOR(4 downto 0)
);
end EX_MEM;

architecture behaviour of EX_MEM is

begin
    
    process(clk) begin
	if (reset) then
		pcPlus4Out <= 32b"0";
		BranchOut <= '0';
        	MemReadOut<= '0';
        	MemtoRegOut <= '0';
        	MemWriteOut <= '0';
        	RegWriteOut <= '0';
        	JumpOut <= '0';
		ALUresultOut <= 32b"0";
		zeroOut <= '0';
		RegData2Out <= 32b"0";
		DstRegOut <= 5b"0";
	else
        	if rising_edge(clk) then
			pcPlus4Out <= pcPlus4;
        		BranchOut <= Branch;
        		MemReadOut<= MemRead;
        		MemtoRegOut <= MemtoReg;
        		MemWriteOut <= MemWrite;
        		RegWriteOut <= RegWrite;
        		JumpOut <= Jump;
			ALUresultOut <= ALUresult;
			zeroOut <= zero;
			RegData2Out <= RegData2;
			DstRegOut <= DstReg;
		end if;
        end if;
    end process;

end behaviour;

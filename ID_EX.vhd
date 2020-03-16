library ieee;
use ieee.std_logic_1164.all;


-- 32-bit rising-edge triggered register with write-enable and asynchronous reset
entity ID_EX is
port (
        clk              : in std_logic; -- Propogate AddressIn to AddressOut on rising edge of clock
	reset            : in STD_LOGIC;
	pcPlus4          : in STD_LOGIC_VECTOR(31 downto 0);
	pcPlus4Out       : out STD_LOGIC_VECTOR(31 downto 0);
	readData1in      : in STD_LOGIC_VECTOR(31 downto 0);
	readData1out     : out STD_LOGIC_VECTOR(31 downto 0);
	readData2in      : in STD_LOGIC_VECTOR(31 downto 0);
	readData2out     : out STD_LOGIC_VECTOR(31 downto 0);
	instExtendedin   : in STD_LOGIC_VECTOR(31 downto 0);
	instExtendedout  : out STD_LOGIC_VECTOR(31 downto 0);
	reg1in           : in STD_LOGIC_VECTOR(4 downto 0);
	reg1out          : out STD_LOGIC_VECTOR(4 downto 0);
        reg2in           : in STD_LOGIC_VECTOR(4 downto 0);
	reg2out          : out STD_LOGIC_VECTOR(4 downto 0);
        reg3in           : in STD_LOGIC_VECTOR(4 downto 0);
        reg3out          : out STD_LOGIC_VECTOR(4 downto 0);
	RegDst           : in STD_LOGIC;
	RegDstOut        : out STD_LOGIC;
        Branch           : in STD_LOGIC;
	BranchOut        : out STD_LOGIC;
        MemRead          : in STD_LOGIC;
	MemReadOut       : out STD_LOGIC;
        MemtoReg         : in STD_LOGIC;
	MemtoRegOut      : out STD_LOGIC;
        MemWrite         : in STD_LOGIC;
	MemWriteOut      : out STD_LOGIC;
        ALUSrc           : in STD_LOGIC;
	ALUSrcOut        : out STD_LOGIC;
        RegWrite         : in STD_LOGIC;
	RegWriteOut      : out STD_LOGIC;
        Jump             : in STD_LOGIC;
	JumpOut          : out STD_LOGIC;
        ALUOp            : in STD_LOGIC_VECTOR(1 downto 0);
	ALUOpOut         : out STD_LOGIC_VECTOR(1 downto 0)
        
);
end ID_EX;

architecture behaviour of ID_EX is

begin
    
    process(clk, reset) begin
	
	if (reset) then
		pcPlus4Out <= 32b"0";
		readData1out <= 32b"0";
		readData2out <= 32b"0";
		instExtendedout <= 32b"0"; 
		reg1out <= 5b"0";
        	reg2out <= 5b"0";
                reg3out <= 5b"0";
		RegDstOut <= '0';
        	BranchOut <= '0';
        	MemReadOut<= '0';
        	MemtoRegOut <= '0';
        	MemWriteOut <= '0';
      		ALUSrcOut <= '0';
        	RegWriteOut <= '0';
        	JumpOut <= '0';
        	ALUOpOut <= "00";
	else
		if rising_edge(clk) then
			pcPlus4Out <= pcPlus4;
			readData1out <= readData1in;
			readData2out <= readData2in;
			instExtendedout <= instExtendedin; 
			reg1out <= reg1in;
        		reg2out <= reg2in;
                        reg3out <= reg3in;
			RegDstOut <= RegDst;
        		BranchOut <= Branch;
        		MemReadOut<= MemRead;
        		MemtoRegOut <= MemtoReg;
        		MemWriteOut <= MemWrite;
      			ALUSrcOut <= ALUSrc;
        		RegWriteOut <= RegWrite;
        		JumpOut <= Jump;
        		ALUOpOut <= ALUOp;
        	end if;
	end if;
    end process;

end behaviour;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PipelinedCPU2 is
port(
     clk :in std_logic;
     rst :in std_logic;
     --Probe ports used for testing or for the tracker.
     DEBUG_IF_SQUASH : out std_logic;
     DEBUG_REG_EQUAL : out std_logic;
     -- Forwarding control signals
     DEBUG_FORWARDA : out std_logic_vector(1 downto 0);
     DEBUG_FORWARDB : out std_logic_vector(1 downto 0);

     --The current address (in various pipe stages)
     DEBUG_PC, DEBUG_PCPlus4_ID, DEBUG_PCPlus4_EX, DEBUG_PCPlus4_MEM,
               DEBUG_PCPlus4_WB: out STD_LOGIC_VECTOR(31 downto 0);
     -- instruction is a store.
     DEBUG_MemWrite, DEBUG_MemWrite_EX, DEBUG_MemWrite_MEM: out STD_LOGIC;
     -- instruction writes the regfile.
     DEBUG_RegWrite, DEBUG_RegWrite_EX, DEBUG_RegWrite_MEM, DEBUG_RegWrite_WB: out std_logic;
     -- instruction is a branch or a jump.
     DEBUG_Branch, DEBUG_Jump: out std_logic;

     DEBUG_PC_WRITE_ENABLE : out STD_LOGIC;
     --The current instruction (Instruction output of IMEM)
     DEBUG_INSTRUCTION : out std_logic_vector(31 downto 0);
     --DEBUG ports from other components
     DEBUG_TMP_REGS : out std_logic_vector(32*4 - 1 downto 0);
     DEBUG_SAVED_REGS : out std_logic_vector(32*4 - 1 downto 0);
     DEBUG_MEM_CONTENTS : out std_logic_vector(32*4 - 1 downto 0)
);
end PipelinedCPU2;

architecture behavior of PipelinedCPU2 is

-- General signals
signal clock_in : STD_LOGIC; -- connect to input clk
signal IF_FLUSH : STD_LOGIC; -- connect to IF/ID pipe
signal reg_equal: STD_LOGIC; -- connect to AND gate for branching 

--------------------------------------------------------------------------------------------
---------------------------------- First Stage ---------------------------------------------
--------------------------------------------------------------------------------------------
signal jAdrs : STD_LOGIC_VECTOR(31 downto 0); -- the computed jump address input to jump mux

-- PC signals
signal nextPC : STD_LOGIC_VECTOR(31 downto 0); -- connect to AddressOut of PC

-- IMEM signals
signal instruction : STD_LOGIC_VECTOR(31 downto 0); -- Connect to IMEM ReadData

-- ADD signals
signal pcAnd4 : STD_LOGIC_VECTOR(31 downto 0); -- connect to output of ADD that increments the PC

-- MUX32 signals
signal calcPCbranch   : STD_LOGIC_VECTOR(31 downto 0); -- connect to output of MUX32 used to compute branch PC
signal newPC          : STD_LOGIC_VECTOR(31 downto 0); -- connect to output of the mux used for jumping

-- IF/ID signals
signal IDpcPlus4Out     : std_logic_vector(31 downto 0);
signal IDinstructionOut : std_logic_vector(31 downto 0);

---------------------------------------------------------------------------------------------
------------------------------------- Second Stage ------------------------------------------
---------------------------------------------------------------------------------------------
-- Hazard detection unit signals
signal HDIfIdWrite : STD_LOGIC; -- connect to IF/IDWrite
signal HDpcWrite   : STD_LOGIC; -- connect to PCWrite
signal HDmuxSel    : STD_LOGIC; -- connect to select line of the MUX following CPU control unit

-- CPU Control MUX signals
signal Mreg_dst    : STD_LOGIC; -- connect to RegDest
signal Mjump       : STD_LOGIC; -- connect to Jump
signal Mbranch     : STD_LOGIC; -- connect to Branch
signal Mmem_read   : STD_LOGIC; -- connect to MemRead
signal Mmem_to_reg : STD_LOGIC; -- connect to MemtoReg
signal Malu_op     : STD_LOGIC_VECTOR(1 downto 0); -- connect to ALUOp
signal Mmem_write  : STD_LOGIC; -- connect to MemWrite
signal Malu_src    : STD_LOGIC; -- connect to ALUSrc
signal Mreg_write  : STD_LOGIC; -- connect to RegWrite

--CPUControl signals
signal reg_dst    : STD_LOGIC; -- connect to RegDest
signal jump       : STD_LOGIC; -- connect to Jump
signal branch     : STD_LOGIC; -- connect to Branch
signal mem_read   : STD_LOGIC; -- connect to MemRead
signal mem_to_reg : STD_LOGIC; -- connect to MemtoReg
signal alu_op     : STD_LOGIC_VECTOR(1 downto 0); -- connect to ALUOp
signal mem_write  : STD_LOGIC; -- connect to MemWrite
signal alu_src    : STD_LOGIC; -- connect to ALUSrc
signal reg_write  : STD_LOGIC; -- connect to RegWrite

-- tracker signals
signal reg_write_tmp     : STD_LOGIC;
signal kill_reg_write_ID : STD_LOGIC;
signal rd_is_0_ID        : STD_LOGIC;

-- registers signals
signal regData1 : STD_LOGIC_VECTOR(31 downto 0); -- connect to RD1
signal regData2 : STD_LOGIC_VECTOR(31 downto 0); -- connect to RD2

-- SignExtend signals
signal extended_val : STD_LOGIC_VECTOR(31 downto 0); -- connect to y

-- ID/EX signals
signal EXpcPlus4Out       : STD_LOGIC_VECTOR(31 downto 0);
signal EXreadData1Out     : STD_LOGIC_VECTOR(31 downto 0);
signal EXreadData2Out     : STD_LOGIC_VECTOR(31 downto 0);
signal EXinstExtendedOut  : STD_LOGIC_VECTOR(31 downto 0);
signal EXreg1Out          : STD_LOGIC_VECTOR(4 downto 0);
signal EXreg2Out          : STD_LOGIC_VECTOR(4 downto 0);
signal EXreg3Out          : STD_LOGIC_VECTOR(4 downto 0);
signal EXRegDstOut        : STD_LOGIC;
signal EXBranchOut        : STD_LOGIC;
signal EXMemReadOut       : STD_LOGIC;
signal EXMemtoRegOut      : STD_LOGIC;
signal EXMemWriteOut      : STD_LOGIC;
signal EXALUSrcOut        : STD_LOGIC;
signal EXRegWriteOut      : STD_LOGIC;
signal EXJumpOut          : STD_LOGIC;
signal EXALUOpOut         : STD_LOGIC_VECTOR(1 downto 0);

----------------------------------------------------------------------------------------------
---------------------------------------- Third Stage -----------------------------------------
----------------------------------------------------------------------------------------------

-- ADD signals
signal add2   : STD_LOGIC_VECTOR(31 downto 0); -- connect to output of ADD that does branching

-- ShiftLeft2 signals
signal extend_lsl2_out  : STD_LOGIC_VECTOR(31 downto 0); -- connect to y of ShiftLeft2 used after sign extend
signal instruction_lsl2 : STD_LOGIC_VECTOR(31 downto 0); -- connect to y of ShiftLeft2 used for instruction shifting

-- MUX_3_2 signals
signal alu_mux_top_input  : STD_LOGIC_VECTOR(31 downto 0); -- connect to output of MUX_3_2 that feeds the top of MUX32 leading into ALU
signal alu_top_input  : STD_LOGIC_VECTOR(31 downto 0); -- connect to output of MUX_3_2 that feeds the top ALU input

-- MUX32 signals
signal alu_bot_input : STD_LOGIC_VECTOR(31 downto 0);

-- ALU signals
signal alu_result : STD_LOGIC_VECTOR(31 downto 0); -- connect to result
signal z_flag     : STD_LOGIC; -- connect to zero
signal v_flag     : STD_LOGIC; -- connect to overflow

-- ALUControl signals
signal op_type : STD_LOGIC_VECTOR(3 downto 0); -- connect to Operation

-- MUX5 signals
signal reg_write_adrs : STD_LOGIC_VECTOR(4 downto 0); -- connect to output of MUX5

-- Forwarding Unit signals
signal topMuxSel : STD_LOGIC_VECTOR(1 downto 0);
signal botMuxSel : STD_LOGIC_Vector(1 downto 0);

-- EX_MEM signals
signal MEMpcPlus4Out   : STD_LOGIC_VECTOR(31 downto 0);
signal MEMBranchOut    : STD_LOGIC;
signal MEMMemReadOut   : STD_LOGIC;
signal MEMMemtoRegOut  : STD_LOGIC;
signal MEMMemWriteOut  : STD_LOGIC;
signal MEMRegWriteOut  : STD_LOGIC;
signal MEMJumpOut      : STD_LOGIC;
signal MEMaddResultOut : std_logic_vector(31 downto 0);
signal MEMALUresultOut : std_logic_vector(31 downto 0);
signal MEMzeroOut      : STD_LOGIC;
signal MEMRegData2Out  : STD_LOGIC_VECTOR(31 downto 0);
signal MEMDstRegOut    : STD_LOGIC_VECTOR(4 downto 0);

--------------------------------------------------------------------------------------
--------------------------------- Fourth Stage ---------------------------------------
--------------------------------------------------------------------------------------

-- AND2 signals
signal PCSrs : STD_LOGIC; -- connect to output of AND2

-- DMEM signals
signal dmem_data : STD_LOGIC_VECTOR(31 downto 0); -- connect to ReadData

-- MEM_WB signals
signal WBpcPlus4Out    : STD_LOGIC_VECTOR(31 downto 0);
signal WBMemtoRegOut   : STD_LOGIC;
signal WBRegWriteOut   : STD_LOGIC;
signal WBdmemDataOut   : std_logic_vector(31 downto 0);
signal WBALUresultOut  : std_logic_vector(31 downto 0);
signal WBDstRegOut     : STD_LOGIC_VECTOR(4 downto 0);

-------------------------------------------------------------------------------------
------------------------------------ Fifth Stage ------------------------------------
-------------------------------------------------------------------------------------

-- MUX32 signals
signal reg_write_data : STD_LOGIC_VECTOR(31 downto 0); -- connect to output of MUX32 used following data memory


begin

clock_in <= clk;

------------------------------------------------------------------------------------------------------------------------------
------------------------------------- Instruction Fetch ----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
PCmap     : entity work.PC port map(clock_in, HDpcWrite, rst, newPC, nextPC);
ADD4      : entity work.ADD port map("00000000000000000000000000000100", nextPC, pcAnd4);
branchMUX : entity work.MUX32 port map(pcAnd4, add2, PCSrs, calcPCbranch);
jumpMUX   : entity work.MUX32 port map(calcPCbranch, jAdrs, jump, newPC);
imem      : entity work.imem port map(nextPC, instruction);
IfId      : entity work.IF_ID port map (clock_in, rst, IF_FLUSH, HDIfIdWrite, pcAnd4, IDpcPlus4Out, instruction, IDinstructionOut);
InstrLSL  : entity work.ShiftLeft2 port map(IDinstructionOut, instruction_lsl2);
jAdrs <= IDpcPlus4Out(31 downto 28) & instruction_lsl2(27 downto 0);
IF_FLUSH <= jump or PCSrs;

-- Testing ports
DEBUG_PC <= nextPC;
DEBUG_INSTRUCTION <= instruction;
DEBUG_IF_SQUASH <= IF_FLUSH;

------------------------------------------------------------------------------------------------------------------------------
------------------------------------- Instruction Decode ---------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
and2 : entity work.AND2 port map(branch, reg_equal, PCSrs);

extended_lsl2 : entity work.ShiftLeft2 port map(extended_val, extend_lsl2_out);

ADDbranch     : entity work.ADD port map(IDpcPlus4Out, extend_lsl2_out, add2);

hazardUnit       : entity work.HazardDetection port map(EXMemReadOut, EXreg1Out, IDinstructionOut(25 downto 21), IDinstructionOut(20 downto 16),
                                                        HDmuxSel, HDpcWrite, HDIfIdWrite);

control          : entity work.cpucontrol port map(IDinstructionOut(31 downto 26), reg_dst, branch, mem_read, mem_to_reg,
                                                   mem_write, alu_src, reg_write_tmp, jump, alu_op);

reg_write <= reg_write_tmp and (not(kill_reg_write_ID));
kill_reg_write_ID <= reg_write_tmp and reg_dst and rd_is_0_ID;
rd_is_0_ID <= '1' when (IDinstructionOut(15 downto 11)="00000") else '0';

controlMux       : entity work.hazardMUX port map(HDmuxSel, reg_dst, branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write,
                                                  jump, alu_op, Mreg_dst, Mbranch, Mmem_read, Mmem_to_reg, Mmem_write,Malu_src,
                                                  Mreg_write, Mjump, Malu_op);

regstrs          : entity work.registers port map(IDinstructionOut(25 downto 21), IDinstructionOut(20 downto 16), WBDstRegOut,
						 reg_write_data, WBRegWriteOut, clock_in, regData1, regData2, DEBUG_TMP_REGS, 
					         DEBUG_SAVED_REGS);

reg_equal <= '1' when regData1 = regData2 else '0';

signExtend       : entity work.SignExtend port map(IDinstructionOut(15 downto 0), extended_val);

IdEx             : entity work.ID_EX port map(clock_in, rst, IDpcPlus4Out, EXpcPlus4Out, regData1, EXreadData1Out, regData2, EXreadData2Out, extended_val, EXinstExtendedOut,
						IDinstructionOut(20 downto 16), EXreg1Out, IDinstructionOut(15 downto 11), EXreg2Out, IDinstructionOut(25 downto 21), EXreg3Out,
						Mreg_dst, EXRegDstOut, Mbranch, EXBranchOut, Mmem_read, EXMemReadOut, Mmem_to_reg, EXMemtoRegOut,
						Mmem_write, EXMemWriteOut, Malu_src, EXALUSrcOut, Mreg_write, EXRegWriteOut, Mjump, EXJumpOut,
						Malu_op, EXALUOpOut);
DEBUG_PC_WRITE_ENABLE <= HDpcWrite;
DEBUG_MemWrite <= Mmem_write;
DEBUG_RegWrite <= reg_write;
DEBUG_Branch <= branch;
DEBUG_Jump <= jump;
DEBUG_PCPlus4_ID <= IDpcPlus4Out;
DEBUG_REG_EQUAL <= reg_equal;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- Execute --------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

topMUX_3_2    : entity work.MUX_3_2 port map(EXreadData1Out, reg_write_data, MEMALUresultOut, topMuxSel, alu_top_input);

botMUX_3_2    : entity work.MUX_3_2 port map(EXreadData2Out, reg_write_data, MEMALUresultOut, botMuxSel, alu_mux_top_input);

aluMUX        : entity work.MUX32 port map(alu_mux_top_input, EXinstExtendedOut, EXALUSrcOut, alu_bot_input);

alu           : entity work.ALU port map(alu_top_input, alu_bot_input, op_type, alu_result, z_flag, v_flag);

aluControl    : entity work.ALUControl port map(EXALUOpOut, EXinstExtendedOut(5 downto 0), op_type);

regWriteMux   : entity work.MUX5 port map(EXreg1Out, EXreg2Out, EXRegDstOut, reg_write_adrs);

forwardUnit   : entity work.forwarding port map(MEMRegWriteOut, WBRegWriteOut, EXreg1Out, EXreg3Out, MEMDstRegOut, WBDstRegOut, topMuxSel, botMuxSel);

ExMem         : entity work.EX_MEM port map(clock_in, rst, EXpcPlus4Out, MEMpcPlus4Out, EXBranchOut, MEMBranchOut, EXMemReadOut, MEMMemReadOut, EXMemtoRegOut, MEMMemtoRegOut,
						EXMemWriteOut, MEMMemWriteOut, EXRegWriteOut, MEMRegWriteOut, EXJumpOut, MEMJumpOut,
						alu_result, MEMALUresultOut, z_flag, MEMzeroOut, alu_mux_top_input,
						MEMRegData2Out, reg_write_adrs, MEMDstRegOut);
DEBUG_FORWARDA <= topMuxSel;
DEBUG_FORWARDB <= botMuxSel;
DEBUG_PCPlus4_EX <= EXpcPlus4Out;
DEBUG_MemWrite_EX <= EXMemWriteOut;
DEBUG_RegWrite_EX <= EXRegWriteOut;

-----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------- Mem -------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

dmem      : entity work.dmem port map(MEMRegData2Out, MEMALUresultOut, MEMMemReadOut, MemMemWriteOut, clock_in, dmem_data, DEBUG_MEM_CONTENTS);
MemWb     : entity work.MEM_WB port map(clock_in, rst, MEMpcPlus4Out, WBpcPlus4Out, MEMMemtoRegOut, WBMemtoRegOut, MEMRegWriteOut, WBRegWriteOut, dmem_data, WBdmemDataOut,
					MEMALUresultOut, WBALUresultOut, MEMDstRegOut, WBDstRegOut);

DEBUG_PCPlus4_MEM <= MEMpcPlus4Out;
DEBUG_MemWrite_MEM <= MEMMemWriteOut;
DEBUG_RegWrite_MEM <= MEMRegWriteOut;

-----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------- WB --------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
dmemMUX   : entity work.MUX32 port map(WBALUresultOut, WBdmemDataOut, WBMemToRegOut, reg_write_data);

DEBUG_PCPlus4_WB <= WBpcPlus4Out;
DEBUG_RegWrite_WB <= WBRegWriteOut;

end;

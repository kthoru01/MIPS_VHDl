library ieee;
use ieee.std_logic_1164.all;

entity hazardMUX is
port(
     sel        : in STD_LOGIC;
     regdstIn   : in STD_LOGIC;
     branchIn   : in STD_LOGIC;
     memreadIn  : in STD_LOGIC;
     memtoregIn : in STD_LOGIC;
     memwriteIn : in STD_LOGIC;
     alusrcIn   : in STD_LOGIC;
     regwriteIn : in STD_LOGIC;
     jumpIn     : in STD_LOGIC;
     aluopIn    : in STD_LOGIC_VECTOR(1 downto 0);
     RegDstOut     : out STD_LOGIC;
     BranchOut     : out STD_LOGIC;
     MemReadOut    : out STD_LOGIC;
     MemtoRegOut   : out STD_LOGIC;
     MemWriteOut   : out STD_LOGIC;
     ALUSrcOut     : out STD_LOGIC;
     RegWriteOut   : out STD_LOGIC;
     JumpOut       : out STD_LOGIC;
     ALUOpOut      : out STD_LOGIC_VECTOR(1 downto 0)
);
end hazardMUX;

-- Behavioral architecture of MUX used for setting controlling bits on hazard
architecture behavioral of hazardMUX is
begin

     process (sel, regdstIn, branchIn, memreadIn, memtoregIn, memwriteIn, alusrcIn, regwriteIn, jumpIn, aluopIn) begin
          if (sel = '0') then
               if ((jumpIn = '1') or (branchIn = '1')) then
                   RegDstOut <= '0';
                   BranchOut <= '0';
                   MemReadOut <= '0';
                   MemtoRegOut <= '0';
                   MemWriteOut <= '0';
                   ALUSrcOut <= '0';
                   RegWriteOut <= '0';
                   JumpOut <= '0';
                   ALUOpOut <= "00";
               else
                   RegDstOut <= regdstIn;
                   BranchOut <= branchIn;
                   MemReadOut <= memreadIn;
                   MemtoRegOut <= memtoregIn;
                   MemWriteOut <= memwriteIn;
                   ALUSrcOut <= alusrcIn;
                   RegWriteOut <= regwriteIn;
                   JumpOut <= jumpIn;
                   ALUOpOut <= aluopIn;
               end if;
          else
               RegDstOut <= '0';
               BranchOut <= '0';
               MemReadOut <= '0';
               MemtoRegOut <= '0';
               MemWriteOut <= '0';
               ALUSrcOut <= '0';
               RegWriteOut <= '0';
               JumpOut <= '0';
               ALUOpOut <= "00";
          end if;
     end process;
       
end behavioral;

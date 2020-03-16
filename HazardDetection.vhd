library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

entity HazardDetection is
port(
	IdExMemRead  : in STD_LOGIC;
        IdExRegRt    : in STD_LOGIC_VECTOR(4 downto 0);
        IfIdRegRs    : in STD_LOGIC_VECTOR(4 downto 0);
        IfIdRegRt    : in STD_LOGIC_VECTOR(4 downto 0);
        selControl   : out STD_LOGIC;
        PCWrite      : out STD_LOGIC;
        IfIdWrite    : out STD_LOGIC
);
end HazardDetection;

-- Logic for MUX_3_2
architecture behavioral of HazardDetection is
begin
     process (IdExMemRead, IdExRegRt, IfIdRegRt, IfIdregRs) begin
          if ((IdExMemRead = '1') and ((IdExRegRt = IfIdRegRs)
               or (IdExRegRt = IfIdRegRt))) then
          
               selControl <= '1';
               PCWrite <= '0';
               IfIdWrite <= '0';

          else
     
              selControl <= '0';
              PCWrite <= '1';
              IfIdWrite <= '1';
          
          end if;
     end process;
            
end behavioral;

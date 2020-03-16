library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

entity forwarding is
port(
	ExMemRegWrite  : in STD_LOGIC;
        MemWbRegWrite  : in STD_LOGIC;
        IdExRegRt      : in STD_LOGIC_VECTOR(4 downto 0);
        IdExRegRs      : in STD_LOGIC_VECTOR(4 downto 0);
        ExMemRegRd     : in STD_LOGIC_VECTOR(4 downto 0);
        MemWbRegRd     : in STD_LOGIC_VECTOR(4 downto 0);
        ForwardA       : out STD_LOGIC_VECTOR(1 downto 0);
        ForwardB       : out STD_LOGIC_VECTOR(1 downto 0)
);
end forwarding;

-- behavioral logic for Forwarding Unit
architecture behavioral of forwarding is
begin
     process (ExMemRegWrite, MemWbRegWrite, IdExRegRt, IdExRegRs, ExMemRegRd, MemWbRegRd) begin
          
           if ((MemWbRegWrite = '1') and (MemWbRegRd /= "00000") and
              not((ExMemRegWrite = '1') and (ExMemRegRd /= "00000") and
              (ExMemregRd = IdExRegRs)) and (MemWbRegRd = IdExRegRs)) then
               
                ForwardA <= "01";
          
           elsif ((ExMemRegWrite = '1') and (ExMemRegRd /= "00000") and
                    (ExMemRegRd = IdExRegRs)) then

                ForwardA <= "10";
    
           else
 
                ForwardA <= "00";

           end if;
          
           if ((MemWbRegWrite = '1') and (MemWbRegRd /= "00000") and
              not((ExMemRegWrite = '1') and (ExMemRegRd /= "00000") and
              (ExMemregRd = IdExRegRt)) and (MemWbRegRd = IdExRegRt)) then
               
                ForwardB <= "01";
          
           elsif ((ExMemRegWrite = '1') and (ExMemRegRd /= "00000") and
                    (ExMemRegRd = IdExRegRt)) then

                ForwardB <= "10";
    
           else
 
                ForwardB <= "00";

           end if;
     end process;

end behavioral;

library ieee;
use ieee.std_logic_1164.all;


-- 32-bit rising-edge triggered register with write-enable and asynchronous reset
entity PC is
port (
        clk          : in std_logic; -- Propogate AddressIn to AddressOut on rising edge of clock 
        write_enable : in std_logic; -- Only write if '1' 
        rst          : in std_logic; -- Asynchronous reset! Sets AddressOut to 0x0 
        AddressIn    : in std_logic_vector(31 downto 0); -- Next PC address 
        AddressOut   : out std_logic_vector(31 downto 0)  -- Current PC address
);
end PC;

architecture behaviour of PC is

begin
    
    process(clk, rst) begin
        if rst = '1' then
            AddressOut <= "00000000000000000000000000000000";
        else
            if rising_edge(clk) then
                if write_enable = '1' then
                    AddressOut <= AddressIn;
                else
                    AddressOut <= AddressOut;
                end if;
             end if;
         end if;
    end process;

end behaviour;

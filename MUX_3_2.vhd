library ieee;
use ieee.std_logic_1164.all;

entity MUX_3_2 is
port(
	in0    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 00
	in1    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 01
        in2    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 10
        sel    : in STD_LOGIC_VECTOR(1 downto 0); -- selects in0 or in1 or in2
	output : out STD_LOGIC_VECTOR(31 downto 0)
);
end MUX_3_2;

-- Logic for MUX_3_2
architecture data_flow of MUX_3_2 is
begin
	output <= in0 when sel = "00" else 
                  in1 when sel = "01" else
                  in2 when sel = "10";
end data_flow;

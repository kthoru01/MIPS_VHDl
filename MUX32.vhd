library ieee;
use ieee.std_logic_1164.all;

entity MUX32 is
port(
	in0    : in std_logic_vector(31 downto 0); -- sel == 0
	in1    : in std_logic_vector(31 downto 0); -- sel == 1
        sel    : in std_logic; -- selects in0 or in1
	output : out std_logic_vector(31 downto 0)
);
end MUX32;

-- Logic for MUX32
architecture data_flow of MUX32 is
begin
	output <= in1 when sel else in0;
end data_flow;

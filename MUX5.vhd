library ieee;
use ieee.std_logic_1164.all;

entity MUX5 is
port(
	in0    : in std_logic_vector(4 downto 0); -- sel == 0
	in1    : in std_logic_vector(4 downto 0); -- sel == 1
        sel    : in std_logic; --selects in0 or in1
	output : out std_logic_vector(4 downto 0)
);
end MUX5;

-- Logic for MUX5
architecture data_flow of MUX5 is
begin
	output <= in1 when sel else in0;
end data_flow;

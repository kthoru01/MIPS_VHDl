library ieee;
use ieee.std_logic_1164.all;

entity AND2 is
port(
	in0    : in std_logic;
	in1    : in std_logic;
	output : out std_logic -- in0 and in1
);
end AND2;


-- Logic for AND2
architecture data_flow of AND2 is
begin
	output <= in0 and in1;
end data_flow;

library ieee;
use ieee.std_logic_1164.all;

entity ShiftLeft2 is -- shifts the input left by 2 bits
port(
	x : in std_logic_vector(31 downto 0);
	y : out std_logic_vector(31 downto 0) -- x << 2
);
end ShiftLeft2;


-- Logic for ShiftLeft2
architecture data_flow of ShiftLeft2 is
begin
	y <=  x(29 downto 0) & "00";
end data_flow;
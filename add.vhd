library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- signed

entity ADD is
-- Adds two signed 32-bit inputs
-- output = in1 + in2
port(
     in0    : in  STD_LOGIC_VECTOR(31 downto 0);
     in1    : in  STD_LOGIC_VECTOR(31 downto 0);
     output : out STD_LOGIC_VECTOR(31 downto 0)
);
end ADD;

architecture logic of ADD is

-- signals used to convert from logic_vector to signed
-- and then back to logic_vector
signal a : signed(31 downto 0); --will correspond to in0
signal b : signed(31 downto 0); --will correspond to in1
signal y : signed(31 downto 0); --will correspond to output

begin
	a <= signed(in0);
	b <= signed(in1);
        y <= a + b;
        output <= std_logic_vector(y);
end logic;

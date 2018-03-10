library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shifter is
    generic(
        nbit:       natural:=   24; -- single mantissa 23 + hidden bit
        shift_bits: natural:=   5   -- ceil(log2(nbit))
    );
    port(
        A:      in  std_logic_vector(nbit-1 downto 0);
        ovf:    in  std_logic;
        shift:  in  std_logic_vector(shift_bits-1 downto 0);
        Z:      out std_logic_vector(nbit-2 downto 0)
    );
end entity shifter;

architecture behavioural of shifter is
begin
    Z   <=  A(nbit-1 downto 1) when ovf = '1' else
            std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(shift))));
end architecture behavioural;

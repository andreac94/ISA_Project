library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library WORK;
use WORK.leading_zero_detection.all;

entity normalizer_logic is
    generic(
        nbit:       natural:=   24; -- single mantissa 23 + hidden bit
        exp_bits:   natural:=   8;  -- single exponent 8
        shift_bits: natural:=   5   -- ceil(log2(nbit))
    );
    port(
        A:          in  std_logic_vector(nbit-1 downto 0);
        exp_S1:     in  std_logic_vector(exp_bits-1 downto 0);
        lz:         out std_logic_vector(shift_bits-1 downto 0)
    );
end entity normalizer_logic;

architecture behavioural of normalizer_logic is
    signal  lz_int: std_logic_vector(shift_bits-1 downto 0);
begin
    lz_int      <=  std_logic_vector(to_unsigned(leading_zeroes(A), shift_bits));
    lz          <=  lz_int when unsigned(exp_S1) > unsigned(lz_int) else
                exp_S1(shift_bits-1 downto 0);
end architecture behavioural;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity exponent_comparator is
    generic(
        nbit:   natural:=   8   -- single precision
    );
    port(
        A:      in  std_logic_vector(nbit-1 downto 0);  -- exponent of A
        B:      in  std_logic_vector(nbit-1 downto 0);  -- exponent of B
        A_gt_B: out std_logic;  -- '1' if exponent of A is greater, '0' otherwise
        diff:   out std_logic_vector(nbit-1 downto 0)   -- abs(A-B)
    );
end entity exponent_comparator;

-- This probably sucks, but hey it should work
architecture behavioural of exponent_comparator is
    signal  A_gt_B_int: std_logic;  -- needed to use output internally
begin
    A_gt_B_int  <=  '1' when unsigned(A) > unsigned(B) else
                    '0';
    A_gt_B      <=  A_gt_B_int;
    -- subtraction needs to work on unsigned or signed
    diff        <=  std_logic_vector(unsigned(A)-unsigned(B)) when A_gt_B_int = '1' else
                    std_logic_vector(unsigned(B)-unsigned(A));
end architecture behavioural;

-- Perform subtractions and use the MSB to get which one is positive, then
-- select the correct result.
-- Needs two adders, but we are working on 8-bit (single) or 13-bit (double)
-- values so the cost is fairly limited. Consider hand-crafting carry select
-- adders for better performance in case the synthesis derps into RCA.
architecture double_adder of exponent_comparator is
    signal  A_gt_B_int: std_logic;  -- easy naming, easy coding
    signal  A_minus_B:  signed(nbit downto 0);
    signal  B_minus_A:  signed(nbit downto 0);
begin
    -- We need signed values to detect sign and thus add a bit (bad beast overflow avoided)
    A_minus_B   <=  signed('0'&A)-signed('0'&B);
    B_minus_A   <=  signed('0'&B)-signed('0'&A);
    -- A is greater than B if B-A is negative
    A_gt_B_int  <=  B_minus_A(B_minus_A'high);
    A_gt_B      <=  A_gt_B_int;
    diff        <=  std_logic_vector(A_minus_B(7 downto 0)) when A_gt_B_int = '1' else
                    std_logic_vector(B_minus_A(7 downto 0));
end architecture double_adder;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity unsigned_comparator is
    generic(
        nbit:   natural:=   24  -- single precision mantissa + hidden bit
    );
    port(
        A:          in  std_logic_vector(nbit-1 downto 0);
        B:          in  std_logic_vector(nbit-1 downto 0);
        A_gt_B:     out std_logic
    );
end entity unsigned_comparator;

architecture behavioural of unsigned_comparator is
begin
    A_gt_B  <=  '1' when unsigned(A) > unsigned(B) else
                '0';
end architecture behavioural;

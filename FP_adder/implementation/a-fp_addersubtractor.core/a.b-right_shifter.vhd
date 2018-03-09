library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity right_shifter is
    generic(
        nbit:               natural:=   24; -- single mantissa 23 + hidden bit
        shift_bits:         natural:=   8;  -- single exponent 8
        needed_shift_bits:  natural:=   5   -- ceil(log2(nbit))
    );
    port(
        A:      in  std_logic_vector(nbit-1 downto 0);
        shift:  in  std_logic_vector(shift_bits-1 downto 0);
        Z:      out std_logic_vector(nbit-1 downto 0);
    );
end component right_shifter;

-- Totally not optimized, but it should work
architecture behavioural of right_shifter is
    -- When the shift uses more than the needed bits the result is zero,
    -- letting us use a smaller shifter
    signal  flush_to_zero:  std_logic;
    
    function group_or(X: std_logic_vector) return std_logic is
        variable    Y:  std_logic:= '0';
    begin
        for i in 0 to X'high loop
            Y:= Y or X(i);
        end loop;
        return Y;
    end function group_or;
begin
    flush_to_zero   <=  group_or(shift(shift'high downto needed_shift_bits));
    Z   <=  (others => '0') when flush_to_zero = '1' else
            std_logic_vector(unsigned(A) srl unsigned(shift(needed_shift_bits-1 downto 0)));
end architecture behavioural;

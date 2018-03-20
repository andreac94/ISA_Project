library IEEE;
use IEEE.std_logic_1164.all;

package leading_zero_detection is

    function leading_zeroes(X: std_logic_vector) return integer;

end package leading_zero_detection;

package body leading_zero_detection is

    function leading_zeroes(X: std_logic_vector) return integer is
        variable    count:  integer;
    begin
        -- Assume input vector has no leading zeroes
        count   :=  0;
        -- Loop through bits from MSB
        for i in X'high downto X'low loop
            -- Whenever a '0' is detected increase count
            if X(i)='0' then
                count   :=  count+1;
            -- At the first '1' detected break loop
            else
                exit;
            end if;
        end loop;
        -- Return count of leading zeroes. If vector has all zeroes, its length will be returned.
        return count;
    end function leading_zeroes;

end package body leading_zero_detection;

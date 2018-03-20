library IEEE;
use IEEE.std_logic_1164.all;

package FP_constants is
    type single is record
        sign:       std_logic;
        exponent:   std_logic_vector(7 downto 0);
        mantissa:   std_logic_vector(22 downto 0);
    end record single;
    
    type double is record
        sign:       std_logic;
        exponent:   std_logic_vector(10 downto 0);
        mantissa:   std_logic_vector(51 downto 0);
    end record double;
    
    function to_single(X: std_logic_vector(31 downto 0)) return single;
    function to_double(X: std_logic_vector(63 downto 0)) return double;
end package FP_constants;

package body FP_constants is
    function to_single(X: std_logic_vector(31 downto 0)) return single is
        variable    Y:  single;
    begin
        Y   <=  (sign => X(31), exponent => X(30 downto 23), mantissa => X(22 downto 0);
        return Y;
    end function to_single;
    
    function to_double(X: std_logic_vector(31 downto 0)) return single is
        variable    Y:  double;
    begin
        Y   <=  (sign => X(63), exponent => X(62 downto 52), mantissa => X(51 downto 0);
        return Y;
    end function to_double;
end package body FP_constants;

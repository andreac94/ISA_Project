library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity FP_div is
  port ( Numerator, Denominator : in  std_logic_vector (31 downto 0);
         Result                 : out std_logic_vector (31 downto 0));
end entity; -- FP_div

architecture behav of FP_div is

  signal signA, signB, signR : std_logic;
  signal expA,  expB , expR  : std_logic_vector (7  downto 0);
  signal fracA, fracB, fracR : std_logic_vector (22 downto 0);

  signal expBinv  : std_logic_vector (7  downto 0);
  signal temp_exp1, temp_exp2 : std_logic_vector (7  downto 0);

begin
  
  -- unpack
  signA <= std_logic(Numerator  (31));
  signB <= std_logic(Denominator(31));
  expA  <= Numerator  (30 downto 23);
  expB  <= Denominator(30 downto 23);
  fracA <= Numerator  (22 downto  0);
  fracB <= Denominator(22 downto  0);

  -- sign
  signR <= signA xor signB;

  -- exponent
  inv: for i in 0 to 7 generate
    expBinv(i) <= not(expB) ;
  end generate;
  temp_exp1 <=  std_logic_vector(unsigned(expA) + unsigned(expBinv));
  temp_exp2(6 downto 0) <= temp_exp1(6 downto 0);
  temp_exp2(7) <= not (temp_exp1(7));

--TODO-- sub part after normalization

  -- fractional

  -- pack
  Result(31) <= std_logic_vector(signR);
  Result(30 downto 23) <= expR;
  Result(22 downto  0) <= fracR;

end architecture; -- behav

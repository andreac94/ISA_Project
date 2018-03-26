library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity FP_div is
  port ( Numerator, Denominator : in  std_logic_vector (31 downto 0);
         Result                 : out std_logic_vector (31 downto 0));
end entity; -- FP_div

architecture behav of FP_div is

  -- components
  component div_b is
    port (A, B : in  std_logic_vector (22 downto 0);
          R, Q : out std_logic_vector (23 downto 0));
  end component; -- div_b

  -- signals
  signal signA, signB, signR : std_logic;
  signal expA,  expB , expR  : std_logic_vector (7  downto 0):= (others => '0');
  signal fracA, fracB, fracR : std_logic_vector (22 downto 0):= (others => '0');
  signal expAextend,  expBextend, exp_extend : std_logic_vector (8  downto 0):= (others => '0');
  signal fracRem, fracQ      : std_logic_vector (23 downto 0):= (others => '0');

  signal temp_exp1, temp_exp2 :std_logic_vector (7  downto 0):= (others => '0');

  signal NaN  :std_logic_vector (31 downto 0):= x"7fffffff";
  signal inf  :std_logic_vector (31 downto 0):= x"7f800000";
  signal zero :std_logic_vector (31 downto 0):= (others => '0');

begin

  -- unpack
  signA <= std_logic(Numerator  (31));
  signB <= std_logic(Denominator(31));
  expA  (7 downto 0)  <= Numerator  (30 downto 23);
  expB  (7 downto 0)  <= Denominator(30 downto 23);
  fracA (22 downto 0) <= Numerator  (22 downto  0);
  fracB (22 downto 0) <= Denominator(22 downto  0);

  -- sign
  signR <= signA xor signB;

  -- exponent
  expAextend(7 downto 0) <= expA(7 downto 0) ;
  expBextend(7 downto 0) <= not(expB(7 downto 0)) ;
  --inv: for i in 0 to 7 generate
  --  expBextend(i) <= not(expB(i)) ;
  --end generate;
  exp_extend <=  std_logic_vector(unsigned(expAextend) + unsigned(expBextend));
  temp_exp2(6 downto 0) <= exp_extend(6 downto 0);
  temp_exp2(7) <= not (exp_extend(7));

  -- fractional
  SRT_radix_2 : div_b port map (fracA, fracB, fracRem, fracQ);

  -- pack

  process (fracQ)
  begin
    if    (expA(7)='1') and (expB(7)='0') and (exp_extend(8)='1') then
      -- overflow
      expR  <= inf(30 downto 23);
      fracR <= inf(22 downto 0);
    elsif (expA(7)='0') and (expB(7)='1') and (temp_exp2(7) ='1') then
      -- underflow
      expR  <= zero(30 downto 23);
      fracR <= zero(22 downto 0);
    else
      -- exponent normalization
      if (fracQ(23) = '0') then
        expR <= std_logic_vector(signed(temp_exp2) - 1);
        fracR(22 downto 1) <= fracQ(21 downto 0);
      else
        expR  <= temp_exp2;
        fracR <= fracQ(22 downto 0);
      end if;

    end if;
  end process;

  -- A=Number ; B=Number
  result(30 downto 23) <= expR;
  result(22 downto  0) <= fracR;



  Result(31) <= signR;

end architecture; -- behav

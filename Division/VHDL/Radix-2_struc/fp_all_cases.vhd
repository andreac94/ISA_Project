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
  signal expAextend,  expBextend, exp_extend : std_logic_vector (8  downto 0):= (others => '0');
  signal fracA, fracB, fracR : std_logic_vector (22 downto 0):= (others => '0');
  signal fracRem, fracQ      : std_logic_vector (23 downto 0):= (others => '0');

  signal temp_exp :std_logic_vector (7  downto 0):= (others => '0');

  signal NaN  :std_logic_vector (31 downto 0):= x"7fffffff";
  signal inf  :std_logic_vector (31 downto 0):= x"7f800000";
  signal zero :std_logic_vector (31 downto 0):= (others => '0');

begin
  
  -- unpack
  signA <= std_logic(Numerator  (31));
  signB <= std_logic(Denominator(31));
  expA  <= Numerator  (30 downto 23);
  expB  <= Denominator(30 downto 23);
  fracA <= Numerator  (22 downto  0);
  fracB <= Denominator(22 downto  0);
  expAextend (7 downto 0) <= expA;

  -- sign
    signR <= signA xor signB;
  -- exponent
    expBextend(7 downto 0) <= not(expB(7 downto 0)) ;
    exp_extend <=  std_logic_vector(unsigned(expAextend) + unsigned(expBextend));
    temp_exp(7) <= not (exp_extend(7));
    temp_exp(6 downto 0) <= exp_extend(6 downto 0);
    -- fractional
    SRT_radix_2 : div_b port map (fracA, fracB, fracRem, fracQ);

  process (Numerator, Denominator)
  begin
    --------------------------
    ---- SPECIAL CASE---------
    --------------------------
    if (expA = "11111111") then

      if (fracA = "00000000000000000000000" ) then               -- A = inf
        if(expB = "11111111") then --B = inf, Nan
          Result(30 downto 0) <= NaN(30 downto 0);
        else                       --B = num,0
          Result(30 downto 0) <= inf(30 downto 0);
        end if;
      else                                                       -- A = NaN
        Result(30 downto 0) <= NaN(30 downto 0);    -- B = any
      end if;

    elsif (expA = "00000000") then                               -- A = 0

      if   (expB = "11111111") then   --B = inf, Nan
        if (fracB = "00000000000000000000000" ) then
          Result(30 downto 0) <= zero(30 downto 0); -- B= inf
        else
          Result(30 downto 0) <= NaN(30 downto 0);  -- B= NaN
        end if ;
      elsif(expB = "00000000") then
          Result(30 downto 0) <= NaN(30 downto 0);  -- B= zero
      else
          Result(30 downto 0) <= zero(30 downto 0); -- B= Num
      end if ;

    else                                                          -- A = Number
      if (expB = "00000000") then
        Result(30 downto 0) <= inf(30 downto 0);  -- B = zero
      elsif (expB = "11111111" ) then
        if (fracB = "00000000000000000000000" ) then
          Result(30 downto 0) <= zero(30 downto 0); -- B= inf
        else
          Result(30 downto 0) <= NaN(30 downto 0);  -- B= NaN
        end if;

      else                -- B = Num
        
        if (exp_extend(8) = '1') then  -- OVERFLOW case
          if( expA(7) = '1') then
            Result(30 downto 0) <= inf(30 downto 0);
          else
            Result(30 downto 0) <= zero(30 downto 0);
          end if;

        else 
          Result(30 downto 23) <= expR;
          Result(22 downto  0) <= fracR;

          -- exponent normalization
          if (fracQ(23) = '0') then
            fracR(22 downto 1) <= fracQ(21 downto 0);
            expR <= std_logic_vector(signed(temp_exp) - 1);
          else
            fracR <= fracQ(22 downto 0);
            expR <= temp_exp;
          end if;

        end if;
      end if;

    end if;
  end process;

  -- pack
  Result(31) <= signR;

end architecture; -- behav

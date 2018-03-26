library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity FP_TestBench is
end FP_TestBench;

architecture tb of FP_TestBench is

  component FP_div is
    port ( Numerator, Denominator : in  std_logic_vector (31 downto 0);
           Result                 : out std_logic_vector (31 downto 0));
  end component; -- FP_div

signal Numerator, Denominator :  std_logic_vector (31 downto 0):= (others => '0');
signal Result                 :  std_logic_vector (31 downto 0):= (others => '0');
signal end_sim : std_logic :=  '1';
constant Ts : time :=  4 ns;
signal CLK : std_logic;


begin

  -- instantiate the unit under test (uut)
  uut : FP_div port map (Numerator,Denominator,Result);

  -- clock process
  process
  begin  -- process
    if (CLK = 'U') then
      CLK <= '0';
    else
      CLK <= not(CLK);
    end if;
    wait for Ts/2;
  end process;

  -- Read stimuli from external file
  process (CLK)
    file fp_in : text open READ_MODE is "inputs32";
    variable line_in : line;
    variable x : std_logic_vector(31 downto 0);
    begin  -- process
      if falling_edge(CLK) then  -- rising clock edge
        if not endfile(fp_in) then
          end_sim <= '0';
          readline(fp_in, line_in);
          read(line_in, x);
          Numerator <=x;
          readline(fp_in, line_in);
          read(line_in, x);
          Denominator <=x;
        else
          end_sim <= '1';
        end if;
      else
        null;
      end if;
  end process;


  -- Write results to an external file
  process (CLK)
    file res_fp : text open WRITE_MODE is ".\resultsFP";
    variable line_out : line;
  begin  -- process
    if rising_edge(CLK) then  -- rising clock edge
      if (end_sim = '0') then
        write(line_out, Result);
        writeline(res_fp, line_out);
      end if;
    else
      null;
    end if;
  end process;


--   -- Test adder_combinatorial
--simulation : process
--  begin
--
--  wait for Ts;
--  A<= "10010000000000000000000";
--  B<= "01000000000000000000000";
--
--  wait;
--end process simulation;

end;

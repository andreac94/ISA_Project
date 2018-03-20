library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity div_behav_TestBench is
end div_behav_TestBench;

architecture tb of div_behav_TestBench is

  component div_b is
    port (
      A, B : in  std_logic_vector (22 downto 0);
      R, Q : out std_logic_vector (27 downto 0));
  end component; -- div_b

  --declare inputs and initialize them to zero.
signal A, B :  std_logic_vector (22 downto 0) := (others => '0') ;
signal R, Q :  std_logic_vector (27 downto 0) := (others => '0') ;
signal In_A :  std_logic_vector (55 downto 0) := (others => '0') ;
signal In_B :  std_logic_vector (55 downto 0) := (others => '0') ;
signal Out_Q:  std_logic_vector (55 downto 0) := (others => '0') ;
signal end_sim : std_logic :=  '0';
--signal out_Q,out_R : std_logic_vector (23 downto 0) := (others => '0') ;
--constant TIME_DELTA : time := 10 ns;
constant Ts : time :=  4 ns;
signal CLK : std_logic;


begin
  In_A (52) <= '1';
  In_A (51 downto 29) <= A;
  In_B (26) <= '1';
  In_B (25 downto  3) <= B;

  -- instantiate the unit under test (uut)
  uut : div_b port map (A, B, R, Q );

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
    file fp_in : text open READ_MODE is "inputs_a";
    variable line_in : line;
    variable x : std_logic_vector(22 downto 0);
    begin  -- process
      if falling_edge(CLK) then  -- rising clock edge
        if not endfile(fp_in) then
          readline(fp_in, line_in);
          read(line_in, x);
          A <=x;
          readline(fp_in, line_in);
          read(line_in, x);
          B <=x;
        else
          end_sim <= '1';
        end if;
      else
        null;
      end if;
  end process;


  -- Write results to an external file
  process (CLK)
    file res_fp : text open WRITE_MODE is ".\results.txt";
    variable line_out : line;
  begin  -- process
    if rising_edge(CLK) then  -- rising clock edge
      if (end_sim = '0') then
        report "ao sto a dividere" severity warning;
        Out_Q <= std_logic_vector(to_unsigned(to_float(unsigned(In_A)) / to_float(unsigned(In_B)),56));
        write(line_out, Q);
        writeline(res_fp, line_out);
      end if;
    else
      null;
    end if;
  end process;


--     -- Test adder_combinatorial
--  simulation : process
--    begin
--
--    wait for TIME_DELTA;
--    A<= "10010000000000000000000";
--    B<= "01000000000000000000000";
--
--    wait;
--  end process simulation;

end;

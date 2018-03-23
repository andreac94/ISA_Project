library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity FP_mul_testbench is
end FP_mul_testbench;

architecture tb of FP_mul_testbench is

  component FP_mul is
	port (
		A, B : in  std_logic_vector(31 downto 0);
		O    : out std_logic_vector(31 downto 0);
		NaN  : out std_logic
	);
  end component;

signal A_i, B_i : std_logic_vector (31 downto 0):= (others => '0');
signal Result   : std_logic_vector (31 downto 0):= (others => '0');
signal end_sim  : std_logic :=  '1';
signal CLK      : std_logic;

constant Ts : time :=  4 ns;


begin

  -- instantiate the unit under test (uut)
  uut : FP_mul port map (A_i, B_i, Result, open);

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
    file fp_in : text open READ_MODE is "FP_mul_inputs.txt";
    variable line_in : line;
    variable x : std_logic_vector(31 downto 0);
    begin  -- process
      if falling_edge(CLK) then  -- rising clock edge
        if not endfile(fp_in) then
          end_sim <= '0';
          readline(fp_in, line_in);
          read(line_in, x);
          A_i <= x;
          readline(fp_in, line_in);
          read(line_in, x);
          B_i <= x;
        else
          end_sim <= '1';
        end if;
      else
        null;
      end if;
  end process;


  -- Write results to an external file
  process (CLK)
    file res_fp : text open WRITE_MODE is "./FP_mul_outputs.txt";
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

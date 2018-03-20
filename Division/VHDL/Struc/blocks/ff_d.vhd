library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

----------------
-- 1 bit regiter
----------------
entity FF_D is
  port (d, clk: in  std_logic;
        q     : out std_logic);
  end FF_D; -- FF_D
architecture behav of FF_D is
  begin
    process (clk)
    begin
      if (clk’event and clk=’1’) then
        q <= d;
      end if;
    end process;
   end behav; --behav

----------------
-- N bit regiter
----------------
entity FF_D_vec is
  generic (N: Integer)
  port (d   : in  std_logic_vector(N-1 downto 0);
        clk : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0);
  end FF_D; -- FF_D_vec
architecture behav of FF_D_vec is
  begin
    process (clk)
    begin
      if (clk’event and clk=’1’) then
        q <= d;
      end if;
    end process;
  end behav; --behav

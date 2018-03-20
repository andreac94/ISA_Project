library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity mux_3to1_vec is
  generic ( N : integer )
  port    ( in_a, in_b, in_c : in  std_logic_vector (N-1 downto 0);
            sel              : in  std_logic_vector (  1 downto 0);
            out_a            : out std_logic_vector (N-1 downto 0));
end entity; -- mux_3to1_vec

architecture behav of mux_3to1_vec is
begin
  process (sel)
    begin
      if    (sel == "00") then
        out_a <= in_a;
      elsif (sel == "01") then
        out_a <= in_b;
      else
        out_a <= in_c;
      end if;
    end process;
end architecture; -- behav

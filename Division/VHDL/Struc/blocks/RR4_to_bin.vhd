--this block transforms the result from Redundant Radix 4 representation to binary

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity RR4_bin is
  generic (N : integer)
  port ( Q      : in  std_logic_vector( N-1    downto 0);
         sign   : in  std_logic_vector((N/2)-1 downto 0);
         result : out std_logic_vector( N-1    downto 0));
end entity; -- RR4_bin

architecture behav of RR4_bin is

  signal pos_q, neg_q : std_logic_vector (N-1 downto 0);

begin

  GEN_vec:
  for I in 0 to (N/2)-1 generate
    process (Q, sign)
      begin
        if (sign = '0') then pos_q(2*N+1 downto 2*N) <= Q(2*N+1 downto 2*N);
        else neg_q(2*N+1 downto 2*N) <= Q(2*N+1 downto 2*N);
      end if;
    end process;
  end generate GEN_vec;
  
  result <= pos_q - neg_q;

end architecture; -- behav

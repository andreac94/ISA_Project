library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

----------
-- FA ----
----------
entity FA is
  Port ( A, B, Cin : in  STD_LOGIC;
         S, Cout   : out STD_LOGIC);
end FA;
architecture struc of FA is
  begin
    S    <= A XOR B XOR Cin ;
    Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B) ;
end struc;

----------
-- HA ----
----------
entity HA is
  Port ( A, B    : in  STD_LOGIC;
         S, Cout : out STD_LOGIC);
end HA;
architecture struc of HA is
  begin
    S    <= A XOR B ;
    Cout <= A AND B ;
end struc;

----------
-- CSA----
----------
entity Carry_Save_Adder is
  generic ( N : integer )
  port    ( A,B,C      : in  std_logic_vector (N-1 downto 0);
            Carry, Sum : out std_logic_vector (N-1 downto 0));
end entity; -- Carry_Save_Adder

architecture struc of Carry_Save_Adder is
  component FA is
    Port ( A, B, Cin : in  STD_LOGIC;
           S, Cout   : out STD_LOGIC);
  end component;
begin
   GEN_FA:
   for I in 0 to N-1 generate
      FAI : FA port map
        (A(I), B(I), C(I), Sum(I), Carry(I));
   end generate GEN_FA;
end architecture; --

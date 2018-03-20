library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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

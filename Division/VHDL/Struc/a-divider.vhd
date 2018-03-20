library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use work.div_config.all;

entity SRT is
  port (
    clk : IN  std_logic ;
    rst : IN  std_logic ;
    A   : IN  std_logic_vector (23 downto 0) ;
    B   : IN  std_logic_vector (23 downto 0) ;
    Q   : OUT std_logic_vector (23 downto 0));
end entity; -- SRT


architecture structural of SRT is

  ------------------------------------------
  ---------- Compoent declaration ----------
  ------------------------------------------
  component mux_3to1_vec is
    generic ( N : integer )
    port    ( in_a, in_b, in_c : in  std_logic_vector (N-1 downto 0);
              sel              : in  std_logic_vector (  1 downto 0);
              out_a            : out std_logic_vector (N-1 downto 0));
  end component; -- mux_3to1_vec

  component FF_D_vec is
    generic (N: Integer)
    port (d   : in  std_logic_vector(N-1 downto 0);
          clk : in  std_logic;
          q   : out std_logic_vector(N-1 downto 0);
  end component; -- FF_D_vec

  component Carry_Save_Adder is
    generic ( N : integer )
    port    ( A,B,C      : in  std_logic_vector (N-1 downto 0);
              Carry, Sum : out std_logic_vector (N-1 downto 0));
  end component; -- Carry_Save_Adder

  component D_selector is
    port (Sum   : in  std_logic_vector(3 downto 0);
          Carry : in  std_logic_vector(3 downto 0);
          D_sel : out std_logic_vector(2 downto 0));
  end entity; -- D_selector

  component RR4_bin is
    generic (N : integer)
    port ( Q      : in  std_logic_vector( N-1    downto 0);
           sign   : in  std_logic_vector((N-1)/2 downto 0);
           result : out std_logic_vector( N-1    downto 0));
  end component; -- RR4_bin

  ------------------------------------------
  ----------- Signal declaration -----------
  ------------------------------------------
  signal B_double : std_logic_vector (2)
  signal zero_s   : std_logic_vector (23 downto 0) : <= others('0');
  signal Divisor  : matrix_24bit (10 downto 0)
  signal D_sel_s  : matrix_3bit  (10 downto 0)
  signal Sum, Carry, new_Carry : matrix_24bit (11 downto 0)

begin

   GEN_div_unit:
   for I in 1 to (N/2)-1 generate

      D_sel_I: D_selector
        port map (Sum(I-1)(23 downto 20), Carry(I-1)(22 downto 19), D_sel_s(I))

      mux_I: mux_3to1_vec
        generic map (24)
        port    map (zero_s, B, B_double, Divisor(I));

      CSA_I : Carry_Save_Adder
        generic map (24)
        port    map (Sum(I-1), new_Carry(I-1), Divisor(I), Sum(I), Carry(I));

   end generate GEN_div_unit;

end architecture; -- structural

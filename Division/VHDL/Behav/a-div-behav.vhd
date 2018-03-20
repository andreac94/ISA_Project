library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use work.div_config.all;

entity div_b is
  port (
    A, B : in  std_logic_vector (22 downto 0);
    R, Q : out std_logic_vector (27 downto 0));
end entity; -- div_b


architecture behav of div_b is

  --components
  component D_selector is
  port (B:        in  std_logic_vector(22 downto 0);
        D_sel:    in  std_logic_vector(3  downto 0);
        Denom:    out std_logic_vector(29 downto 0);
        Pos, Neg: out std_logic_vector( 1 downto 0));
  end component; -- D_selector

  --signals
  signal N   : std_logic_vector (29 downto 0) := (others => '0');
  signal D   : matrix_30bit (13 downto 0);
  signal fR  : matrix_30bit (13 downto 0);
  signal nR  : matrix_30bit (14 downto 0);
  --signal Dsel: matrix_4bit  (3 downto 0);
  signal Pos_q, Neg_q: std_logic_vector (27 downto 0) ;

begin

  -- CREATE operating signals
  N(24) <= '1';
  N(23 downto  1) <= A;

  nR(0) <= N;

  -- START computation
  Gen_comp : for i in 0 to 13 generate
    fR(i) (29 downto 2) <= nR(i) (27 downto 0);
    fR(i) ( 1 downto 0) <= (others =>'0');
    --Dsel(i) <= fR(i) (29 downto 26);

    D_sel_I : D_selector port map(
      B, fR(i)(29 downto 26), D(i),
      Pos_q (27-(2*i) downto (27-(2*i+1))), Neg_q(27-(2*i) downto (27-(2*i+1))));

    nR(i+1) <= std_logic_vector(signed(fR(i)) + signed(D(i)));

  end generate; -- Gen_comp

  -- Assign Results
  R <= nR (14)(27 downto 0);
  Q <= std_logic_vector(signed(Pos_q) - signed(Neg_q));

end architecture; -- behav

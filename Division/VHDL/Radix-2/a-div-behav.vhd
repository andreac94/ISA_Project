library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use work.div_config.all;

entity div_b is
  port (A, B : in  std_logic_vector (22 downto 0);
        R, Q : out std_logic_vector (23 downto 0));
end entity; -- div_b


architecture behav of div_b is

  --components
  component D_selector is
  port (B:        in  std_logic_vector(22 downto 0);
        D_sel:    in  std_logic_vector(1  downto 0);
        Denom:    out std_logic_vector(25 downto 0);
        Pos, Neg: out std_logic);
  end component; -- D_selector

  --signals
  signal Num : std_logic_vector (25 downto 0) := (others => '0');
  signal D        : matrix_26bit (23 downto 0);
  signal doubleR  : matrix_26bit (23 downto 0);
  signal remainder: matrix_26bit (24 downto 0);
  signal tP,tN    : matrix_1bit  (23 downto 0);
  --signal Dsel: matrix_4bit  (3 downto 0);
  signal Pos_q, Neg_q: std_logic_vector (23 downto 0) ;

begin

  -- CREATE operating signals
  Num(23) <= '1';
  Num(22 downto  0) <= A;

  remainder(0) <= Num;

  -- START computation
  Gen_comp : for i in 0 to 23 generate
    doubleR(i) (25 downto 1) <= remainder(i) (24 downto 0);
    doubleR(i) ( 0 downto 0) <= (others =>'0');
    --Dsel(i) <= doubleR(i) (29 downto 26);

    D_sel_I : D_selector port map(
      B, doubleR(i)(25 downto 24), D(i), tP(i), tN(i));

    Pos_q (23-i) <= tP(i);
    Neg_q (23-i) <= tN(i);

    remainder(i+1) <= std_logic_vector(signed(doubleR(i)) + signed(D(i)));

  end generate; -- Gen_comp

  -- Assign Results
  R <= remainder (14)(23 downto 0);
  Q <= std_logic_vector(signed(Pos_q) - signed(Neg_q));

end architecture; -- behav

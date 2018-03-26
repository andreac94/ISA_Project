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
        D_sel:    in  std_logic_vector(3  downto 0);
        Denom:    out std_logic_vector(25 downto 0);
        Pos, Neg: out std_logic;
        sign:     out std_logic);
  end component; -- D_selector

  component Carry_Save_Adder is
    generic ( N : integer );
    port    ( A,B,C      : in  std_logic_vector (N-1 downto 0);
              Carry, Sum : out std_logic_vector (N-1 downto 0));
  end component; -- Carry_Save_Adder

  --signals
  signal Num : std_logic_vector (25 downto 0) := (others => '0');
  signal D        : matrix_26bit (23 downto 0):= (others => (others => '0'));
  signal doubleS  : matrix_26bit (23 downto 0):= (others => (others => '0'));
  signal doubleC  : matrix_26bit (23 downto 0):= (others => (others => '0'));
  signal result_r : matrix_26bit (23 downto 0):= (others => (others => '0'));
  signal selector : matrix_4bit  (23 downto 0):= (others => (others => '0'));
  signal Sum      : matrix_26bit (24 downto 0):= (others => (others => '0'));
  signal Carry    : matrix_26bit (24 downto 0):= (others => (others => '0'));
  signal tP,tN    : matrix_1bit  (23 downto 0);
  signal sign     : matrix_1bit  (23 downto 0);
  signal Pos_q, Neg_q: std_logic_vector (23 downto 0) ;

begin

  -- CREATE operating signals
  Num(23) <= '1';
  Num(22 downto  0) <= A;

  Sum(0) <= Num;

  -- START computation
  Gen_comp : for i in 0 to 23 generate

    doubleS(i) (25 downto 1) <= Sum(i) (24 downto 0);
    doubleC(i) (25 downto 2) <= Carry(i) (23 downto 0);
    selector(i) <= std_logic_vector(unsigned(Carry(i)(24 downto 21)) + unsigned(Sum(i)(25 downto 22)));
    result_r(i) <= std_logic_vector(unsigned(doubleC(i)) + unsigned(doubleS(i)));

    D_sel_I : D_selector
      port map (B, selector(i), D(i), tP(i), tN(i), sign(i));

    doubleC(i) (0) <= sign(i);
    Pos_q (23-i)   <= tP(i);
    Neg_q (23-i)   <= tN(i);

    CSA_i : Carry_Save_Adder  generic map ( 26 )
      port map    ( doubleS(i),D(i),DoubleC(i), Carry(i+1), Sum(i+1));

  end generate; -- Gen_comp

  -- Assign Results
  R <= Sum (14)(23 downto 0);
  Q <= std_logic_vector(signed(Pos_q) - signed(Neg_q));

end architecture; -- behav

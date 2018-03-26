library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity D_selector is
  port (B:        in  std_logic_vector(22 downto 0);
        D_sel:    in  std_logic_vector(1  downto 0);
        Denom:    out std_logic_vector(25 downto 0);
        Pos, Neg: out std_logic);
end entity; -- D_selector

architecture behav of D_selector is
  signal D, two_D, three_D  : std_logic_vector(25 downto 0) := (others =>'0');
  signal neg_D, neg2D, neg3D: std_logic_vector(25 downto 0) := (others =>'0');
  signal zero : std_logic_vector(25 downto 0) := (others =>'0');
  signal err  : std_logic_vector(25 downto 0) := (others =>'X');

begin
  D(24) <= '1';
  D(23 downto  1) <= B;
  neg_D <= std_logic_vector(signed(zero) - signed(D));

  process (D_sel, D, zero, neg_D)

  begin
    case1: case D_sel is
      when "01"    => Denom <= neg_D; Pos <= '1'; Neg <= '0';
      when "10"    => Denom <= D;     Pos <= '0'; Neg <= '1';
      when others  => Denom <= zero;  Pos <= '0'; Neg <= '0'; -- error case
    end case;

  end process;

end architecture; -- behav

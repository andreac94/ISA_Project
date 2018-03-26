library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity D_selector is
  port (B:        in  std_logic_vector(22 downto 0);
        D_sel:    in  std_logic_vector(3  downto 0);
        Denom:    out std_logic_vector(25 downto 0);
        Pos, Neg: out std_logic;
        sign:     out std_logic);
end entity; -- D_selector

architecture behav of D_selector is
  signal D, two_D, three_D  : std_logic_vector(25 downto 0) := (others =>'0');
  signal neg_D, neg2D, neg3D: std_logic_vector(25 downto 0) := (others =>'0');
  signal zero : std_logic_vector(25 downto 0) := (others =>'0');
  signal err  : std_logic_vector(25 downto 0) := (others =>'X');

begin
  D(24) <= '1';
  D(23 downto  1) <= B;
  neg_D <= not (D);

  process (D_sel, D, zero, neg_D)

  begin
    case1: case D_sel is
      when "0111"    => Denom <= neg_D; Pos <= '1'; Neg <= '0'; sign <= '1';
      when "0110"    => Denom <= neg_D; Pos <= '1'; Neg <= '0'; sign <= '1';
      when "0101"    => Denom <= neg_D; Pos <= '1'; Neg <= '0'; sign <= '1';
      when "0100"    => Denom <= neg_D; Pos <= '1'; Neg <= '0'; sign <= '1';
      when "0011"    => Denom <= neg_D; Pos <= '1'; Neg <= '0'; sign <= '1';
      when "0010"    => Denom <= neg_D; Pos <= '1'; Neg <= '0'; sign <= '1';
      when "0001"    => Denom <= neg_D; Pos <= '1'; Neg <= '0'; sign <= '1';
      when "0000"    => Denom <= neg_D; Pos <= '1'; Neg <= '0'; sign <= '1';

      when "1101"    => Denom <= D;     Pos <= '0'; Neg <= '1'; sign <= '0';
      when "1100"    => Denom <= D;     Pos <= '0'; Neg <= '1'; sign <= '0';
      when "1011"    => Denom <= D;     Pos <= '0'; Neg <= '1'; sign <= '0';
      when "1010"    => Denom <= D;     Pos <= '0'; Neg <= '1'; sign <= '0';
      when "1001"    => Denom <= D;     Pos <= '0'; Neg <= '1'; sign <= '0';
      when "1000"    => Denom <= D;     Pos <= '0'; Neg <= '1'; sign <= '0';

      when others  => Denom <= zero;  Pos <= '0'; Neg <= '0'; sign <= '0';
    end case;

  end process;

end architecture; -- behav

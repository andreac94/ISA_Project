library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity D_selector is
  port (B:        in  std_logic_vector(22 downto 0);
        D_sel:    in  std_logic_vector(3  downto 0);
        Denom:    out std_logic_vector(29 downto 0);
        Pos, Neg: out std_logic_vector( 1 downto 0));
end entity; -- D_selector

architecture behav of D_selector is
  signal D, two_D, three_D  : std_logic_vector(29 downto 0) := (others =>'0');
  signal neg_D, neg2D, neg3D: std_logic_vector(29 downto 0) := (others =>'0');
  signal zero : std_logic_vector(29 downto 0) := (others =>'0');

begin
  D(26) <= '1';
  D(25 downto  3) <= B;
  two_D   (29 downto 1) <= D(28 downto 0);
  three_D (29 downto 2) <= D(27 downto 0);
  neg_D <= std_logic_vector(signed(zero) - signed(D));
  neg2D <= std_logic_vector(signed(zero) - signed(two_D));
  neg3D <= std_logic_vector(signed(zero) - signed(three_D));

  process (D_sel, three_D, two_D, D, zero, neg_D, neg2D, neg3D )
  begin
    case1: case D_sel is
      when "1000" => Denom <= three_D;
      when "1001" => Denom <= three_D;
      when "1010" => Denom <= three_D;

      when "1011" => Denom <= two_D;
      when "1100" => Denom <= two_D;

      when "1101" => Denom <= D;
      when "1110" => Denom <= D;

      when "1111" => Denom <= zero;
      when "0000" => Denom <= zero;

      when "0001" => Denom <= neg_D;
      when "0010" => Denom <= neg_D;

      when "0011" => Denom <= neg2D;
      when "0100" => Denom <= neg2D;

      when "0101" => Denom <= neg3D;
      when "0110" => Denom <= neg3D;
      when "0111" => Denom <= neg3D;

      when others  => Denom <= zero; -- error case
    end case;

    case2: case D_sel is
      when "1000" => Pos <= "00"; Neg <= "11";
      when "1001" => Pos <= "00"; Neg <= "11";
      when "1010" => Pos <= "00"; Neg <= "11";

      when "1011" => Pos <= "00"; Neg <= "10";
      when "1100" => Pos <= "00"; Neg <= "10";

      when "1101" => Pos <= "00"; Neg <= "01";
      when "1110" => Pos <= "00"; Neg <= "01";

      when "1111" => Pos <= "00"; Neg <= "00";
      when "0000" => Pos <= "00"; Neg <= "00";

      when "0001" => Pos <= "01"; Neg <= "00";
      when "0010" => Pos <= "01"; Neg <= "00";

      when "0011" => Pos <= "10"; Neg <= "00";
      when "0100" => Pos <= "10"; Neg <= "00";

      when "0101" => Pos <= "11"; Neg <= "00";
      when "0110" => Pos <= "11"; Neg <= "00";
      when "0111" => Pos <= "11"; Neg <= "00";

      when others  => Pos <= "00"; Neg <="00"; -- error case
    end case;
  end process;

end architecture; -- behav

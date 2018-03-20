library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity D_selector is
  port (
    Sum   : in  std_logic_vector(3 downto 0);
    Carry : in  std_logic_vector(3 downto 0);
    D_sel : out std_logic_vector(2 downto 0) );
end entity; -- D_selector

architecture behav of D_selector is
  signal address: std_logic_vecto  (7 downto 0);
  signal zero   : std_logic_vector (2 downto 0):="000";
  signal one    : std_logic_vector (2 downto 0):="001";
  signal two    : std_logic_vector (2 downto 0):="010";
  signal neg_one: std_logic_vector (2 downto 0):="101";
  signal neg_two: std_logic_vector (2 downto 0):="110";

begin
  address <= Sum & Carry;

  case address is
    when "00000000" => D_sel <= zero;
    when "11110000" => D_sel <= zero;
    when "11100001" => D_sel <= zero;
    when "11010010" => D_sel <= zero;
    when "11000011" => D_sel <= zero;
    when "10110100" => D_sel <= zero;
    when "10100101" => D_sel <= zero;
    when "10010110" => D_sel <= zero;
    when "10000111" => D_sel <= zero;
    when "01111000" => D_sel <= zero;
    when "01101001" => D_sel <= zero;
    when "01011010" => D_sel <= zero;
    when "01001011" => D_sel <= zero;
    when "00111100" => D_sel <= zero;
    when "00101101" => D_sel <= zero;
    when "00011110" => D_sel <= zero;
    when "00001111" => D_sel <= zero;

    when "00010000" => D_sel <= one;
    when "00000001" => D_sel <= one;
    when "00100000" => D_sel <= one;
    when "00010000" => D_sel <= one;
    when "00000010" => D_sel <= one;

    when "00110000" => D_sel <= two;
    when "00100001" => D_sel <= two;
    when "00010010" => D_sel <= two;
    when "00000011" => D_sel <= two;
    when "01000000" => D_sel <= two;
    when "00110001" => D_sel <= two;
    when "00100010" => D_sel <= two;
    when "00010011" => D_sel <= two;
    when "00000100" => D_sel <= two;
    when "01010000" => D_sel <= two;
    when "01000001" => D_sel <= two;
    when "00110010" => D_sel <= two;
    when "00100011" => D_sel <= two;
    when "00010100" => D_sel <= two;
    when "00000101" => D_sel <= two;
    when "01100000" => D_sel <= two;
    when "01010001" => D_sel <= two;
    when "01000010" => D_sel <= two;
    when "00110011" => D_sel <= two;
    when "00100100" => D_sel <= two;
    when "00010101" => D_sel <= two;
    when "00000110" => D_sel <= two;
    when "01110000" => D_sel <= two;
    when "01100001" => D_sel <= two;
    when "01010010" => D_sel <= two;
    when "01000011" => D_sel <= two;
    when "00110100" => D_sel <= two;
    when "00100101" => D_sel <= two;
    when "00010110" => D_sel <= two;
    when "00000111" => D_sel <= two;

    when "10000000" => D_sel <= neg_two;
    when "01110001" => D_sel <= neg_two;
    when "01100010" => D_sel <= neg_two;
    when "01010011" => D_sel <= neg_two;
    when "01000100" => D_sel <= neg_two;
    when "00110101" => D_sel <= neg_two;
    when "00100110" => D_sel <= neg_two;
    when "00010111" => D_sel <= neg_two;
    when "00001000" => D_sel <= neg_two;
    when "10010000" => D_sel <= neg_two;
    when "10000001" => D_sel <= neg_two;
    when "01110010" => D_sel <= neg_two;
    when "01100011" => D_sel <= neg_two;
    when "01010100" => D_sel <= neg_two;
    when "01000101" => D_sel <= neg_two;
    when "00110110" => D_sel <= neg_two;
    when "00100111" => D_sel <= neg_two;
    when "00011000" => D_sel <= neg_two;
    when "00001001" => D_sel <= neg_two;
    when "10100000" => D_sel <= neg_two;
    when "10010001" => D_sel <= neg_two;
    when "10000010" => D_sel <= neg_two;
    when "01110011" => D_sel <= neg_two;
    when "01100100" => D_sel <= neg_two;
    when "01010101" => D_sel <= neg_two;
    when "01000110" => D_sel <= neg_two;
    when "00110111" => D_sel <= neg_two;
    when "00101000" => D_sel <= neg_two;
    when "00011001" => D_sel <= neg_two;
    when "00001010" => D_sel <= neg_two;
    when "10110000" => D_sel <= neg_two;
    when "10100001" => D_sel <= neg_two;
    when "10010010" => D_sel <= neg_two;
    when "10000011" => D_sel <= neg_two;
    when "01110100" => D_sel <= neg_two;
    when "01100101" => D_sel <= neg_two;
    when "01010110" => D_sel <= neg_two;
    when "01000111" => D_sel <= neg_two;
    when "00111000" => D_sel <= neg_two;
    when "00101001" => D_sel <= neg_two;
    when "00011010" => D_sel <= neg_two;
    when "00001011" => D_sel <= neg_two;
    when "11000000" => D_sel <= neg_two;
    when "10110001" => D_sel <= neg_two;
    when "10100010" => D_sel <= neg_two;
    when "10010011" => D_sel <= neg_two;
    when "10000100" => D_sel <= neg_two;
    when "01110101" => D_sel <= neg_two;
    when "01100110" => D_sel <= neg_two;
    when "01010111" => D_sel <= neg_two;
    when "01001000" => D_sel <= neg_two;
    when "00111001" => D_sel <= neg_two;
    when "00101010" => D_sel <= neg_two;
    when "00011011" => D_sel <= neg_two;
    when "00001100" => D_sel <= neg_two;

    when "11010000" => D_sel <= neg_one;
    when "11000001" => D_sel <= neg_one;
    when "10110010" => D_sel <= neg_one;
    when "10100011" => D_sel <= neg_one;
    when "10010100" => D_sel <= neg_one;
    when "10000101" => D_sel <= neg_one;
    when "01110110" => D_sel <= neg_one;
    when "01100111" => D_sel <= neg_one;
    when "01011000" => D_sel <= neg_one;
    when "01001001" => D_sel <= neg_one;
    when "00111010" => D_sel <= neg_one;
    when "00101011" => D_sel <= neg_one;
    when "00011100" => D_sel <= neg_one;
    when "00001101" => D_sel <= neg_one;
    when "11100000" => D_sel <= neg_one;
    when "11010001" => D_sel <= neg_one;
    when "11000010" => D_sel <= neg_one;
    when "10110011" => D_sel <= neg_one;
    when "10100100" => D_sel <= neg_one;
    when "10010101" => D_sel <= neg_one;
    when "10000110" => D_sel <= neg_one;
    when "01110111" => D_sel <= neg_one;
    when "01101000" => D_sel <= neg_one;
    when "01011001" => D_sel <= neg_one;
    when "01001010" => D_sel <= neg_one;
    when "00111011" => D_sel <= neg_one;
    when "00101100" => D_sel <= neg_one;
    when "00011101" => D_sel <= neg_one;
    when "00001110" => D_sel <= neg_one;

    when other => D_sel <= "111"; -- error case
  end case;
end architecture; -- behav

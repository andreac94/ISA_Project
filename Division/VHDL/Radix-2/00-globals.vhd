library ieee;
use ieee.std_logic_1164.all;

package div_config is
  type    matrix_26bit is array (integer range <>) of std_logic_vector(25 downto 0);
  type    matrix_4bit  is array (integer range <>) of std_logic_vector( 3 downto 0);
  type    matrix_1bit  is array (integer range <>) of std_logic;
end div_config;

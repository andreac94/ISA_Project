library ieee;
use ieee.std_logic_1164.all;

package div_config is
  type    matrix_24bit is array (integer range <>) of std_logic_vector(23 downto 0);
  type    matrix_3bit  is array (integer range <>) of std_logic_vector( 2 downto 0);
end div_config;

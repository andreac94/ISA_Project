library ieee;
use ieee.std_logic_1164.all;

package div_config is
  type    matrix_30bit is array (integer range <>) of std_logic_vector(29 downto 0);
  type    matrix_4bit  is array (integer range <>) of std_logic_vector( 3 downto 0);
end div_config;

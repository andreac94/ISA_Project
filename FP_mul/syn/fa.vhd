library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity FA is
	port (A, B, C_in : in  std_logic;
	      S, C_out   : out std_logic
	);
end FA;

architecture behavioural of FA is

	signal I : std_logic;

begin

	I     <= A xor B;
	S     <= I xor C_in;
	C_out <= (A and B) or (I and C_in);

end architecture;

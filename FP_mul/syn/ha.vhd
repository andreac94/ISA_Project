library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity HA is
	port (A, B : in  std_logic;
	      S, C : out std_logic
	);
end HA;

architecture behavioural of HA is 
begin

	S <= A xor B;
	C <= A and B;

end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RSH_NORMALIZER is
	generic (N : natural);
	port (
		I : in  std_logic_vector(N-1 downto 0);
		O : out std_logic_vector(N-1 downto 0);
		
		rsh : out std_logic
	);
end RSH_NORMALIZER;

architecture behavioural of RSH_NORMALIZER is begin

	rsh <= I(N-1);

	shift: process(I) is begin
	
		if (I(N-1) = '1') then
			O(N-1) <= '0';
			O(N-2 downto 0) <= I(N-1 downto 1);
			
		else
			O <= I;
			
		end if;
	
	end process;

end architecture;
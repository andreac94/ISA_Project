library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity EXP_MANAGER_UNIT is
	generic (N : natural);
	port (
		A, B : in  std_logic_vector(N-1 downto 0);
		O    : out std_logic_vector(N-1 downto 0);
		
		rsh  : in  std_logic_vector(1 downto 0)
	);
end EXP_MANAGER_UNIT;

architecture arch of EXP_MANAGER_UNIT is

	signal sum_biased   : unsigned(N downto 0); -- N+1 bits to ensure correctness before unbiasing
	signal sum_unbiased : unsigned(N downto 0);
	signal sum_shifted  : unsigned(N downto 0);

begin

	sum_biased   <= unsigned(std_logic_vector'('0' & A)) + unsigned(std_logic_vector'('0' & B));
	sum_unbiased <= sum_biased - (2**(N-1) - 1);
	sum_shifted  <= sum_unbiased + unsigned(std_logic_vector'("" & rsh(0))) + unsigned(std_logic_vector'("" & rsh(1)));
	
	process (A, B, rsh, sum_shifted) is begin
	
		if (sum_shifted(N) = '1') then -- NaN, infinity or overflow
			O <= (others => '1');
			
		else
			O <= std_logic_vector(sum_shifted(N-1 downto 0));
		
		end if;
			
	end process;

end architecture;
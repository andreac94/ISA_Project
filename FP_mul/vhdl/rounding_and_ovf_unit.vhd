library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity ROUNDING_AND_OVF_UNIT is
	generic (
		N    : natural;
		mode : boolean -- true = nearest even; false = truncate
	);
	port (
		I : in  std_logic_vector(2*N-1 downto 0);
		O : out std_logic_vector(  N-2 downto 0);
		
		rsh  : out std_logic_vector(1 downto 0)
	);
end ROUNDING_AND_OVF_UNIT;

architecture struct of ROUNDING_AND_OVF_UNIT is

	component RSH_NORMALIZER
		generic (N : natural);
		port (
			I : in  std_logic_vector(N-1 downto 0);
			O : out std_logic_vector(N-1 downto 0);
			
			rsh : out std_logic
		);
	end component;
	
	signal input  : std_logic_vector(2*N-1 downto 0);
	signal output : std_logic_vector(2*N-1 downto 0);
	
begin

	RSH0: RSH_NORMALIZER generic map (2*N) port map (I, input, rsh(0));

	nearest_even: if (mode) generate
			
		signal sum    : std_logic_vector(2*N-1 downto 0);
		
		signal inter  : integer;
		
		signal lsb    : std_logic;
		signal guard  : std_logic;
		signal sticky : std_logic;
		signal round  : std_logic;
	
	begin
	
		lsb    <= input(N-1);
		guard  <= input(N-2);
		sticky <= or_reduce(input(N-3 downto 0));
		
		round <= (lsb and guard) or (guard and sticky);
		
		inter <= to_integer(unsigned(input)) + to_integer(unsigned'("" & round));
		sum   <= std_logic_vector(to_unsigned(inter, 2*N));
		
		RSH1: RSH_NORMALIZER generic map (2*N) port map (sum, output, rsh(1));
		
	end generate;
	
	truncate: if not (mode) generate
	
		output <= input;
		rsh(1) <= '0';
	
	end generate;
	
	O <= output(2*N-3 downto N-1);

end architecture;
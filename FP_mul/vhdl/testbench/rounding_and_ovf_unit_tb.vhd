library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROUNDING_AND_OVF_UNIT_TB is
end ROUNDING_AND_OVF_UNIT_TB;

architecture sim of ROUNDING_AND_OVF_UNIT_TB is

	component ROUNDING_AND_OVF_UNIT
		generic (
			N    : natural;
			mode : boolean -- true = nearest even; false = truncate
		);
		port (
			I : in  std_logic_vector(2*N-1 downto 0);
			O : out std_logic_vector(  N-2 downto 0);
			
			rsh : out std_logic_vector(1 downto 0)
		);
	end component;

	signal test_I   : std_logic_vector(17 downto 0);
	signal test_O   : std_logic_vector(7 downto 0);
	signal test_rsh : std_logic_vector(1 downto 0);

begin

	DUT: ROUNDING_AND_OVF_UNIT generic map (8+1, false) port map(test_I, test_O, test_rsh);

	stimulus: process is
		variable v_I : integer;
	begin

		for v_I in 0 to 2**18-1 loop

				test_I   <= std_logic_vector(to_unsigned(v_I, test_I'length));
				
				wait for 10 ns;

		end loop;
		
		wait;

	end process;

end architecture;

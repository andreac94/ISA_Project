library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity EXP_MANAGER_UNIT_TB is
end EXP_MANAGER_UNIT_TB;

architecture test of EXP_MANAGER_UNIT_TB is

	component EXP_MANAGER_UNIT
		generic (N : natural);
		port (
			A, B : in  std_logic_vector(N-1 downto 0);
			O    : out std_logic_vector(N-1 downto 0);
			
			rsh  : in  std_logic_vector(1 downto 0)
		);
	end component;

	signal test_A   : std_logic_vector(7 downto 0) := (others => '1');
	signal test_B   : std_logic_vector(7 downto 0);
	signal test_O   : std_logic_vector(7 downto 0);
	signal test_rsh : std_logic_vector(1 downto 0);

begin

	DUT: EXP_MANAGER_UNIT generic map (8) port map(test_A, test_B, test_O, test_rsh);

	stimulus: process is
		variable v_A   : integer;
		variable v_B   : integer;
		variable v_rsh : integer;
	begin

		wait for 10 ns;
	
		for v_A in 0 to 2**8-1 loop
			for v_B in 0 to 2**8-1 loop
				for v_rsh in 0 to 1 loop

					test_A   <= std_logic_vector(to_unsigned(v_A, test_A'length));
					test_B   <= std_logic_vector(to_unsigned(v_B, test_B'length));
					test_rsh <= std_logic_vector(to_unsigned(v_rsh, test_rsh'length));
					
					wait for 10 ns;
				
				end loop;
			end loop;
		end loop;
		
		wait;

	end process;

end architecture;
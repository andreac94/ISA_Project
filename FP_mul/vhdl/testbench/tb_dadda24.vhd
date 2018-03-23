library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DADDA_24_TB is
end DADDA_24_TB;

architecture sim of DADDA_24_TB is

	component DADDA_24
		port (M1, M2 : in  std_logic_vector(23 downto 0);
		      PROD   : out std_logic_vector(47 downto 0)
		);
	end component;

	signal test_m1   : std_logic_vector(23 downto 0);
	signal test_m2   : std_logic_vector(23 downto 0);
	signal test_prod : std_logic_vector(47 downto 0);
	signal dut_ok    : boolean;

begin

	DUT: DADDA_24 port map(test_m1, test_m2, test_prod);

	-- Test for assert
	dut_ok <= to_integer(unsigned(test_m1) * to_integer(unsigned(test_m2))) = to_integer(unsigned(test_prod));

	stimulus: process is
		variable v_a : integer;
		variable v_b : integer;
	begin

		for v_a in 0 to 16777215 loop
			for v_b in 0 to 16777215 loop

				test_m1   <= std_logic_vector(to_unsigned(v_a, test_m1'length));
				test_m2   <= std_logic_vector(to_unsigned(v_b, test_m1'length));
				
				wait for 10 ns;
				assert dut_ok report "DUT FAILURE" severity ERROR;

			end loop;
		end loop;
		
		wait;

	end process;

end architecture;

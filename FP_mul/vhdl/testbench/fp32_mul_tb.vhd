library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity FP32_MUL_TB is
end FP32_MUL_TB;

architecture test of FP32_MUL_TB is

	component FP32_MUL
		port (
			A, B : in  std_logic_vector(31 downto 0);
			O    : out std_logic_vector(31 downto 0);
			NaN  : out std_logic
		);
	end component;

	signal test_A   : std_logic_vector(31 downto 0);
	signal test_B   : std_logic_vector(31 downto 0);
	signal test_O   : std_logic_vector(31 downto 0);
	signal test_NaN : std_logic;

begin

	DUT: FP32_MUL port map(test_A, test_B, test_O, test_NaN);

	stimulus: process is begin

		test_A <= "0" & "10000000" & "00000000000000000000000"; -- 0 * 1
		test_B <= "0" & "10000001" & "00000000000000000000000";
		
		wait for 10 ns;
		
		test_A <= "0" & "10000000" & "00000000000000000000000"; -- 0 * -1
		test_B <= "1" & "10000001" & "00000000000000000000000";
		
		wait for 10 ns;
		
		test_A <= "0" & "10001101" & "00010000000001000111000"; -- two positive numbers
		test_B <= "0" & "10000101" & "00000010000100011000100";
		
		wait for 10 ns;
		
		test_A <= "1" & "10001101" & "00010000000001000111000"; -- two negative numbers
		test_B <= "1" & "10000101" & "00000010000100011000100";
		
		wait for 10 ns;
		
		test_A <= "0" & "00000000" & "00000000000000000000000"; -- 0*0
		test_B <= "0" & "00000000" & "00000000000000000000000";
		
		wait for 10 ns;
		
		test_A <= "0" & "11111111" & "00000000000000000000000"; -- inf * -inf
		test_B <= "1" & "11111111" & "00000000000000000000000";
		
		wait for 10 ns;
		
		test_A <= "0" & "11111111" & "00000000000111000000000"; -- NaN * -inf
		test_B <= "1" & "11111111" & "00000000000000000000000";
		
		wait for 10 ns;
		
		wait;

	end process;

end architecture;
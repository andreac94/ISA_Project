library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity FP_mul is
	port (
		A, B : in  std_logic_vector(31 downto 0);
		O    : out std_logic_vector(31 downto 0);
		NaN  : out std_logic
	);
end FP_mul;

architecture structural of FP_mul is

	component EXP_MANAGER_UNIT
		generic (N : natural);
		port (
			A, B : in  std_logic_vector(N-1 downto 0);
			O    : out std_logic_vector(N-1 downto 0);
			
			rsh  : in  std_logic_vector(1 downto 0)
		);
	end component;

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

	component DADDA_24
		port (M1, M2 : in  std_logic_vector(23 downto 0);
			  PROD   : out std_logic_vector(47 downto 0)
		);
	end component;
	
	signal sign_A : std_logic;
	signal sign_B : std_logic;
	signal sign_O : std_logic;
	
	signal exp_A   : std_logic_vector(7 downto 0);
	signal exp_B   : std_logic_vector(7 downto 0);
	signal exp_O   : std_logic_vector(7 downto 0);
	signal exp_out : std_logic_vector(7 downto 0);
	signal rsh     : std_logic_vector(1 downto 0);
	
	signal nan_input  : std_logic;
	signal zero_input : std_logic;
	signal inf_input  : std_logic;
	signal inf_result : std_logic;
	
	signal mant_A  : std_logic_vector(23 downto 0);
	signal mant_B  : std_logic_vector(23 downto 0);
	signal mant_O  : std_logic_vector(22 downto 0);
	signal rounded : std_logic_vector(22 downto 0);
	signal prod    : std_logic_vector(47 downto 0);

begin
	
	nan_input  <= (and_reduce(exp_A) and or_reduce(mant_A(22 downto 0))) or (and_reduce(exp_B) and or_reduce(mant_B(22 downto 0)));
	zero_input <= (nor_reduce(exp_A) and nor_reduce(mant_A(22 downto 0))) or (nor_reduce(exp_B) and nor_reduce(mant_B(22 downto 0)));	
	inf_input  <= (and_reduce(exp_A) and nor_reduce(mant_A(22 downto 0))) or (and_reduce(exp_B) and nor_reduce(mant_B(22 downto 0)));
	
	NaN       <= nan_input or (zero_input and inf_input);
	------------------------------------- SIGN
	sign_A <= A(31);
	sign_B <= B(31);
	
	sign_O <= sign_A xor sign_B;
	
	------------------------------------- EXPONENT
	exp_A <= A(30 downto 23);
	exp_B <= B(30 downto 23);
	
	EXPONENT: EXP_MANAGER_UNIT generic map (8)  port map (exp_A, exp_B, exp_out, rsh);
	
	inf_result <= and_reduce(exp_out);
	
	process (exp_A, exp_B, exp_out, zero_input, nan_input, inf_input) is begin
	
		if (nan_input = '1' or (zero_input = '1' and inf_input = '1')) then
			exp_O <= (others => '1');
			
		elsif (nan_input = '0' and zero_input = '1' and inf_input = '0') then
			exp_O <= (others => '0');
			
		else
			exp_O <= exp_out;
			
		end if;
		
	end process;
	
	
	------------------------------------- MANTISSA
	mant_A <= or_reduce(exp_A) & A(22 downto 0);
	mant_B <= or_reduce(exp_B) & B(22 downto 0);
	
	DADDA: DADDA_24                                       port map (mant_A, mant_B, prod);
	ROUND: ROUNDING_AND_OVF_UNIT generic map (23+1, false) port map (prod, rounded, rsh);
	
	process (rounded, nan_input, inf_input, inf_result, zero_input) is begin
	
		if (nan_input or (inf_input and zero_input)) = '1' then
			mant_O <= (0 => '1', others => '0');
	
		elsif (nan_input = '0' and inf_result = '1') then
			mant_O <= (others => '0');
			
		else
			mant_O <= rounded;
		
		end if;
	
	end process;
	
	------------------------------------- OUTPUT
	O <= sign_O & exp_O & mant_O;

end architecture;

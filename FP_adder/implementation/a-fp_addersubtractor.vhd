library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library WORK;
use WORK.integer_array.all;

entity FP_AdderSubtractor is
    generic(
        nbit:   natural:=   32
    );
    port(
        A:      in  std_logic_vector(nbit-1 downto 0);
        B:      in  std_logic_vector(nbit-1 downto 0);
        sub:    in  std_logic;
        S:      out std_logic_vector(nbit-1 downto 0)
    );
end entity FP_AdderSubtractor;

architecture structural_single of FP_AdderSubtractor is

    component exponent_comparator is
        generic(
            nbit:   natural:=   8   -- single precision
        );
        port(
            A:          in  std_logic_vector(nbit-1 downto 0);  -- exponent of A
            B:          in  std_logic_vector(nbit-1 downto 0);  -- exponent of B
            A_gt_B:     out std_logic;  -- '1' if exponent of A is greater, '0' otherwise
            diff:       out std_logic_vector(nbit-1 downto 0)   -- abs(A-B)
        );
    end component exponent_comparator;

    component right_shifter is
        generic(
            nbit:               natural:=   24; -- single mantissa 23 + hidden bit
            shift_bits:         natural:=   8;  -- single exponent 8
            needed_shift_bits:  natural:=   5   -- ceil(log2(nbit))
        );
        port(
            A:      in  std_logic_vector(nbit-1 downto 0);
            shift:  in  std_logic_vector(shift_bits-1 downto 0);
            Z:      out std_logic_vector(nbit-1 downto 0)
        );
    end component right_shifter;
    
    component effective_operation is
        port(
            sub:            in  std_logic;
            sign_A:         in  std_logic;
            sign_B:         in  std_logic;
            expA_gt_expB:   in  std_logic;
            eop:            out std_logic
        );
    end component effective_operation;
    
    component unsigned_comparator is
        generic(
            nbit:   natural:=   24  -- single precision mantissa + hidden bit
        );
        port(
            A:          in  std_logic_vector(nbit-1 downto 0);
            B:          in  std_logic_vector(nbit-1 downto 0);
            A_gt_B:     out std_logic
        );
    end component unsigned_comparator;
    
    component unsigned_adder is
        generic(
            nbit:       natural:=   24; -- single mantissa 23 + hidden bit
            CSA_groups: natural:=   7;  -- number of groups in the CSA
            group_taps: int_array:= (1, 3, 6, 10, 14, 19, 24)   -- position of group stops in CSA
        );
        port(
            A:      in  std_logic_vector(nbit-1 downto 0);
            B:      in  std_logic_vector(nbit-1 downto 0);
            sub:    in  std_logic;  -- perform A-B when sub = '1'
            S:      out std_logic_vector(nbit-1 downto 0);
            ovf:    out std_logic;
            zero:   out std_logic   -- result is null
        );
    end component unsigned_adder;
    
    component normalizer_logic is
        generic(
            nbit:       natural:=   24; -- single mantissa 23 + hidden bit
            exp_bits:   natural:=   8;  -- single exponent 8
            shift_bits: natural:=   5   -- ceil(log2(nbit))
        );
        port(
            A:      in  std_logic_vector(nbit-1 downto 0);
            exp_S1: in  std_logic_vector(exp_bits-1 downto 0);
            lz:     out std_logic_vector(shift_bits-1 downto 0)
        );
    end component normalizer_logic;
    
    component exponent_updater is
        generic(
            nbit:       natural:=   8;
            shift_bits: natural:=   5
        );
        port(
            A:      in  std_logic_vector(nbit-1 downto 0);
            B:      in  std_logic_vector(shift_bits-1 downto 0);
            ovf:    in  std_logic;
            D:      out std_logic_vector(nbit-1 downto 0);
            to_inf: out std_logic
        );
    end component exponent_updater;
    
    component shifter is
        generic(
            nbit:       natural:=   24; -- single mantissa 23 + hidden bit
            shift_bits: natural:=   5   -- ceil(log2(nbit))
        );
        port(
            A:      in  std_logic_vector(nbit-1 downto 0);
            ovf:    in  std_logic;
            shift:  in  std_logic_vector(shift_bits-1 downto 0);
            Z:      out std_logic_vector(nbit-2 downto 0)
        );
    end component shifter;
    
    component sign_unit is
        port(
            expA_gt_expB:   in  std_logic;
            sub:            in  std_logic;
            sign_A:         in  std_logic;
            sign_B:         in  std_logic;
            X1_gt_Y:        in  std_logic;
            sign_S:         out std_logic
        );
    end component sign_unit;
    
    component special_case_unit is
        generic(
            nbit:       natural:=   32;
            exp_bits:   natural:=   8;
            man_bits:   natural:=   23
        );
        port(
            A:      in  std_logic_vector(nbit-1 downto 0);
            B:      in  std_logic_vector(nbit-1 downto 0);
            sub:    in  std_logic;
            is_inf: out std_logic;
            is_nan: out std_logic
        );
    end component special_case_unit;
    
    -- GENERAL
    -- unpack bits
    signal  sign_A: std_logic;
    signal  sign_B: std_logic;
    signal  exp_A:  std_logic_vector(7 downto 0);
    signal  exp_B:  std_logic_vector(7 downto 0);
    signal  man_A:  std_logic_vector(22 downto 0);
    signal  man_B:  std_logic_vector(22 downto 0);

    -- EXPONENT CHAIN
    -- exponent comparison
    signal  expA_gt_expB:   std_logic;
    signal  exp_diff:       std_logic_vector(7 downto 0);    
    -- tentative sum exponent
    signal  exp_S1: std_logic_vector(7 downto 0);
    -- final sum exponent
    signal  exp_S:  std_logic_vector(7 downto 0);
    
    -- MANTISSA CHAIN
    -- rearrange and extend mantissas
    constant    den_exp:    std_logic_vector(7 downto 0):=  (others=>'0');
    signal      X:          std_logic_vector(23 downto 0);
    signal      Y:          std_logic_vector(23 downto 0);
    -- align
    signal  X1: std_logic_vector(23 downto 0);
    -- effective operation
    signal  eop:    std_logic;
    -- subtraction wizardry
    signal  Y1:         std_logic_vector(23 downto 0);
    signal  X1_gt_Y:    std_logic;
    signal  beta:       std_logic;
    signal  gamma:      std_logic;
    -- result
    signal  ovf:            std_logic;
    signal  zero:           std_logic;
    signal  S1:             std_logic_vector(23 downto 0);
    signal  S2:             std_logic_vector(23 downto 0);
    signal  leading_zeroes: std_logic_vector(4 downto 0);
    signal  man_S:          std_logic_vector(22 downto 0);
    
    -- SIGN CHAIN
    -- rearrange signs
    signal  sign_X: std_logic;
    signal  sign_Y: std_logic;
    -- sum sign
    signal  sign_S:     std_logic;
    
    -- SPECIAL CASES
    signal  always_inf: std_logic;
    signal  is_nan:     std_logic;
    signal  ovf_to_inf: std_logic;
    signal  is_inf:     std_logic;
    
    -- special values
    constant    inf:    std_logic_vector(31 downto 0):= (30 downto 23=>'1', others=>'0');
    constant    nan:    std_logic_vector(31 downto 0):= (30 downto 22=>'1', others=>'0');
    
begin

    -- unpack bits
    sign_A  <=  A(31);
    sign_B  <=  B(31);
    exp_A   <=  A(30 downto 23);
    exp_B   <=  B(30 downto 23);
    man_A   <=  A(22 downto 0);
    man_B   <=  B(22 downto 0);
    
    -- EXPONENT CHAIN
    -- Find bigger exponent
    EC: exponent_comparator
        generic map(
            nbit    =>  8
        )
        port map(
            A       =>  exp_A,
            B       =>  exp_B,
            A_gt_B  =>  expA_gt_expB,
            diff    =>  exp_diff
        );
    -- Tentative exponent
    exp_S1  <=  exp_B when expA_gt_expB = '0' else
                exp_A;
    -- Correct exponent
    EU: exponent_updater
        generic map(
            nbit    =>  8
        )
        port map(
            A       =>  exp_S1,
            B       =>  leading_zeroes,
            ovf     =>  ovf,
            D       =>  exp_S,
            to_inf  =>  ovf_to_inf
        );
    
    -- MANTISSA CHAIN
    -- rearrange and extend mantissas
    X   <=  '1'&man_A when (expA_gt_expB = '0') and (exp_A /= den_exp) else
            '0'&man_A when (expA_gt_expB = '0') and (exp_A = den_exp) else
            '1'&man_B when (expA_gt_expB = '1') and (exp_B /= den_exp) else
            '0'&man_B;
    Y   <=  '1'&man_B when expA_gt_expB = '0' and exp_B /= den_exp else
            '0'&man_B when expA_gt_expB = '0' and exp_B = den_exp else
            '1'&man_A when expA_gt_expB = '1' and exp_A /= den_exp else
            '0'&man_A;
    -- align
    RS: right_shifter
        generic map(
            nbit                =>  24,
            shift_bits          =>  8,
            needed_shift_bits   =>  5
        )
        port map(
            A       =>  X,
            shift   =>  exp_diff,
            Z       =>  X1
        );
    -- effective operation
    EO: effective_operation
        port map(
            sub             =>  sub,
            sign_A          =>  sign_A,
            sign_B          =>  sign_B,
            expA_gt_expB    =>  expA_gt_expB,
            eop             =>  eop
        );
    -- subtraction wizardry
    Y1      <=  Y when eop = '0' else
            not(Y);
    CM: unsigned_comparator
        generic map(
            nbit    =>  24
        )
        port map(
            A       =>  X1,
            B       =>  Y,
            A_gt_B  =>  X1_gt_Y
        );
    beta    <=  X1_gt_Y and eop;
    gamma   <=  not(X1_gt_Y) and eop;
    -- result
    UA: unsigned_adder
        generic map(
            nbit        =>  24,
            CSA_groups  =>  7,  -- number of groups in the CSA
            group_taps  =>  (1, 3, 6, 10, 14, 19, 24)   -- position of group stops in CSA
        )
        port map(
            A       =>  X1,  
            B       =>  Y1,
            sub     =>  beta,
            S       =>  S1,
            ovf     =>  ovf,
            zero    =>  zero
        );
    S2  <=  S1 when gamma = '0' else
            not(S1);
    NL: normalizer_logic
        generic map(
            nbit        =>  24,
            exp_bits    =>  8,
            shift_bits  =>  5
        )
        port map(
            A       =>  S2,
            exp_S1  =>  exp_S1,
            lz      =>  leading_zeroes
        );
    SH: shifter
        generic map(
            nbit        =>  24,
            shift_bits  =>  5
        )
        port map(
            A       =>  S2,
            ovf     =>  ovf,
            shift   =>  leading_zeroes,
            Z       =>  man_S
        );
    
    -- SIGN CHAIN
    -- rearrange signs
    sign_X  <=  sign_A when expA_gt_expB = '0' else
                sign_B;
    sign_Y  <=  sign_B when expA_gt_expB = '0' else
                sign_A;
    -- sum sign
    SU: sign_unit
        port map(
            expA_gt_expB    =>  expA_gt_expB,
            sub             =>  sub,
            sign_A          =>  sign_A,
            sign_B          =>  sign_B,
            X1_gt_Y         =>  X1_gt_Y,
            sign_S          =>  sign_S
        );
    
    -- SPECIAL CASES
    SCU: special_case_unit
        generic map(
            nbit        =>  32,
            exp_bits    =>  8,
            man_bits    =>  23
        )
        port map(
            A       =>  A,
            B       =>  B,
            sub     =>  sub,
            is_inf  =>  always_inf,
            is_nan  =>  is_nan
        );
    is_inf  <=  always_inf or ovf_to_inf;
    -- select correct output and pack bits
    S   <=  sign_S & exp_S & man_S when is_inf = '0' and is_nan = '0' else
            sign_S & inf(30 downto 0) when is_inf = '1' and is_nan = '0' else
            nan;

end architecture structural_single;

configuration cfg_fpas of FP_AdderSubtractor is
    for structural_single
        for UA: unsigned_adder
            use configuration work.cfg_ua;
        end for;
    end for;
end configuration cfg_fpas;

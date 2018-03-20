library IEEE;
use IEEE.std_logic_1164.all;

entity special_case_unit is
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
end entity special_case_unit;

architecture behavioural of special_case_unit is
    signal  sign_A: std_logic;
    signal  sign_B: std_logic;
    signal  exp_B:  std_logic_vector(exp_bits-1 downto 0);
    signal  exp_A:  std_logic_vector(exp_bits-1 downto 0);
    signal  man_A:  std_logic_vector(man_bits-1 downto 0);
    signal  man_B:  std_logic_vector(man_bits-1 downto 0);
    
    constant    inf_exp:    std_logic_vector(exp_bits-1 downto 0):= (others=>'1');
    constant    inf_man:    std_logic_vector(man_bits-1 downto 0):= (others=>'0');
    constant    nan_exp:    std_logic_vector(exp_bits-1 downto 0):= (others=>'1');
begin
    
    sign_A  <=  A(nbit-1);
    sign_B  <=  B(nbit-1);
    exp_A   <=  A(nbit-2 downto man_bits);
    exp_B   <=  B(nbit-2 downto man_bits);
    man_A   <=  A(man_bits-1 downto 0);
    man_B   <=  B(man_bits-1 downto 0);
    
    --  result is (+-)inf when:
    --      (+-)inf     +-  (+-)finite
    --      (+-)finite  +-  (+-)inf
    --      (+-)inf     +   (+-)inf
    --      (+-)inf     -   (-+)inf
    --  result is nan when:
    --      nan         +-  any
    --      any         +-  nan
    --      (+-)inf     -   (+-)inf
    --      (+-)inf     +   (-+)inf
    --  result is finite when:
    --      all others
    is_inf  <=  '1' when exp_A = inf_exp and man_A = inf_man and exp_B /= nan_exp else
                '1' when exp_A /= nan_exp and exp_B = inf_exp and man_B = inf_man else
                '1' when exp_A = inf_exp and man_A = inf_man and A = B and sub = '0' else
                '1' when exp_A = inf_exp and man_A = inf_man and A(nbit-2 downto 0) = B(nbit-2 downto 0) and sign_A /= sign_B and sub = '1' else
                '0';
    is_nan  <=  '1' when exp_A = nan_exp and man_A /= inf_man else
                '1' when exp_B = nan_exp and man_B /= inf_man else
                '1' when exp_A = inf_exp and man_A = inf_man and A = B and sub = '1' else
                '1' when exp_A = inf_exp and man_A = inf_man and A(nbit-2 downto 0) = B(nbit-2 downto 0) and sign_A /= sign_B and sub = '0' else
                '0';
end architecture behavioural;

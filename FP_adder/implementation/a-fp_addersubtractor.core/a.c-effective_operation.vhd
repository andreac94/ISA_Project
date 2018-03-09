library IEEE;
use IEEE.std_logic_1164.all;

entity effective_operation is
    port(
        sub:            in  std_logic;
        sign_A:         in  std_logic;
        sign_B:         in  std_logic;
        expA_gt_expB:   in  std_logic;
        eop:            out std_logic;
        invert:         out std_logic
    );
end entity effective_operation;

architecture behavioural of effective_operation is
begin
    eop     <=  sub when sign_A = sign_B else
                not(sub);
    invert  <=  '1' when sign_A = '0' and sign_B = '0' and expA_gt_expB = '1' and sub = '1' else
                '1' when sign_A = '0' and sign_B = '1' and expA_gt_expB = '1' and sub = '0' else
                '1' when sign_A = '1' and sign_B = '0' and expA_gt_expB = '0' and sub = '0' else
                '1' when sign_A = '1' and sign_B = '0' and expA_gt_expB = '0' and sub = '1' else
                '1' when sign_A = '1' and sign_B = '0' and expA_gt_expB = '1' and sub = '1' else
                '1' when sign_A = '1' and sign_B = '1' and expA_gt_expB = '0' and sub = '0' else
                '1' when sign_A = '1' and sign_B = '1' and expA_gt_expB = '0' and sub = '1' else
                '1' when sign_A = '1' and sign_B = '1' and expA_gt_expB = '1' and sub = '0' else
                '0';
end architecture behavioural;

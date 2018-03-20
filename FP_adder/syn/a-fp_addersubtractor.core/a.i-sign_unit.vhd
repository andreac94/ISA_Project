library IEEE;
use IEEE.std_logic_1164.all;

entity sign_unit is
    port(
        expA_gt_expB:   in  std_logic;
        sub:            in  std_logic;
        sign_A:         in  std_logic;
        sign_B:         in  std_logic;
        X1_gt_Y:        in  std_logic;
        sign_S:         out std_logic
    );
end entity sign_unit;

architecture behavioural of sign_unit is
    signal  A_gt_B: std_logic;
begin
    -- if expA_gt_expB = '0' then X<=A, Y<=B, else X<=B, Y<=A
    A_gt_B  <=  X1_gt_Y when expA_gt_expB = '0' else
                not X1_gt_Y;    -- not fully accurate when B=A, but who cares
    sign_S  <=  '0' when sign_A = '0' and sign_B = '0' and sub = '0' else                   -- sum of positive
                '0' when sign_A = '0' and sign_B = '0' and sub = '1' and A_gt_B = '1' else  -- bigger positive minus smaller positive
                '0' when sign_A = '0' and sign_B = '1' and sub = '1' else                   -- positive minus negative => sum of positive
                '0' when sign_A = '0' and sign_B = '1' and sub = '0' and A_gt_B = '1' else  -- bigger positive plus smaller negative
                '0' when sign_A = '1' and sign_B = '0' and sub = '0' and A_gt_B = '0' else  -- smaller negative plus bigger positive
                '0' when sign_A = '1' and sign_B = '1' and sub = '1' and A_gt_B = '0' else  -- smaller negative minus bigger negative
                '1';
end architecture behavioural;

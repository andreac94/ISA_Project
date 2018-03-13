library IEEE;
use IEEE.std_logic_1164.all;

entity effective_operation is
    port(
        sub:            in  std_logic;
        sign_A:         in  std_logic;
        sign_B:         in  std_logic;
        expA_gt_expB:   in  std_logic;
        eop:            out std_logic
    );
end entity effective_operation;

architecture behavioural of effective_operation is
begin
    eop     <=  sub when sign_A = sign_B else
                not(sub);
end architecture behavioural;

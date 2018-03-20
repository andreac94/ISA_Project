library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity exponent_updater is
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
end entity exponent_updater;

architecture behavioural of exponent_updater is
    signal      D_int:      std_logic_vector(nbit-1 downto 0);
    constant    inf_exp:    std_logic_vector(nbit-1 downto 0):= (others=>'1');
begin
    D_int   <=  std_logic_vector(unsigned(A)+1) when ovf = '1' else
                std_logic_vector(unsigned(A)-unsigned(B));
    D       <=  D_int;
    to_inf  <=  '1' when D_int = inf_exp else
                '0';
end architecture behavioural;

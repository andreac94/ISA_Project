library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library WORK;
use WORK.integer_array.all;

entity unsigned_adder is
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
        ovf:    out std_logic;  -- overflow
        zero:   out std_logic   -- result is null
    );
end entity unsigned_adder;


-- Simple behavioural adder/subtractor
architecture behavioural of unsigned_adder is

    signal  S_int:  std_logic_vector(nbit-1 downto 0);
    
    function group_nor(X: std_logic_vector) return std_logic is
        variable    Y:  std_logic:= '0';
    begin
        for i in 0 to X'high loop
            Y:= Y or X(i);
        end loop;
        return not Y;
    end function group_nor;

begin
    S_int   <=  std_logic_vector(unsigned(A)+unsigned(B)) when sub = '0' else
                std_logic_vector(unsigned(A)+unsigned(B)+1);
    S       <=  S_int;
    zero    <=  group_nor(S_int);
    ovf     <=  '1' when sub = '0' and A(A'high) = '1' and B(B'high) = '1' else   -- A>N/2, B>N/2
                '1' when sub = '0' and A(A'high) = '1' and S_int(S_int'high) = '0' else   -- A>N/2, A+B<N/2
                '1' when sub = '0' and B(B'high) = '1' and S_int(S_int'high) = '0' else   -- idem with B
                '0';
end architecture behavioural;


RCA adder/subtractor
architecture RCA of unsigned_adder is

    component FullAdder is
        port(
            A:  in  std_logic;
            B:  in  std_logic;
            Ci: in  std_logic;
            S:  out std_logic;
            Co: out std_logic
        );
    end component FullAdder;
    
    signal  carry_chain:    std_logic_vector(nbit downto 0);
    signal  B_neg:          std_logic_vector(nbit-1 downto 0);
    signal  Y:              std_logic_vector(nbit-1 downto 0);
    signal  S_int:          std_logic_vector(nbit-1 downto 0);

    function group_nor(X: std_logic_vector) return std_logic is
        variable    Y:  std_logic:= '0';
    begin
        for i in 0 to X'high loop
            Y:= Y or X(i);
        end loop;
        return not Y;
    end function group_nor;
    
begin
    -- Needed for the generate statement
    carry_chain(0)  <=  sub;
    
    -- We need a negation for subtraction
    B_neg           <=  not B;
    Y               <=  B when sub = '0' else
                        B_neg;

    gen_adder: for i in 0 to nbit-1 generate
        FA: FullAdder
            port map(
                A   =>  A(i),
                B   =>  Y(i),
                Ci  =>  carry_chain(i),
                S   =>  S_int(i),
                Co  =>  carry_chain(i+1)
            );
    end generate gen_adder;
    
    S       <=  S_int;
    ovf     <=  '1' when sub = '0' and A(A'high) = '1' and B(B'high) = '1' else   -- A>N/2, B>N/2
                '1' when sub = '0' and A(A'high) = '1' and S_int(S_int'high) = '0' else   -- A>N/2, A+B<N/2
                '1' when sub = '0' and B(B'high) = '1' and S_int(S_int'high) = '0' else   -- idem with B
                '0';
    zero    <=  group_nor(S_int);
end architecture RCA;


-- Linear Carry Save Adder with variable group size
architecture CSA of unsigned_adder is

    component FullAdder is
        port(
            A:  in  std_logic;
            B:  in  std_logic;
            Ci: in  std_logic;
            S:  out std_logic;
            Co: out std_logic
        );
    end component FullAdder;
    
    signal  B_neg:          std_logic_vector(nbit-1 downto 0);
    signal  Y:              std_logic_vector(nbit-1 downto 0);
    signal  S_int:          std_logic_vector(nbit-1 downto 0);

    function group_nor(X: std_logic_vector) return std_logic is
        variable    Y:  std_logic:= '0';
    begin
        for i in 0 to X'high loop
            Y:= Y or X(i);
        end loop;
        return not Y;
    end function group_nor;

begin
    -- We need a negation for subtraction
    B_neg           <=  not B;
    Y               <=  B when sub = '0' else
                        B_neg;

    gen_adder: for i in 0 to CSA_groups-1 generate
        signal  selector_chain:    std_logic_vector(CSA_groups downto 1);
    begin
        first_group: if i = 0 generate
            signal  carry_chain:    std_logic_vector(group_taps(i) downto 0);
        begin
            carry_chain(0)  <=  sub;
            
            gen_first_group: for j in 0 to group_taps(i)-1 generate
                FA: FullAdder
                    port map(
                        A   =>  A(j),
                        B   =>  Y(j),
                        Ci  =>  carry_chain(j),
                        S   =>  S_int(j),
                        Co  =>  carry_chain(j+1)
                    );
            end generate gen_first_group;
            
            selector_chain(i+1) <=  carry_chain(carry_chain'high);
        end generate first_group;
        
        other_groups: if i /= 0 generate
            signal  carry_chain_1:    std_logic_vector(group_taps(i) downto group_taps(i-1));
            signal  carry_chain_2:    std_logic_vector(group_taps(i) downto group_taps(i-1));
            
            signal  S1: std_logic_vector(group_taps(i) downto group_taps(i-1));
            signal  S2: std_logic_vector(group_taps(i) downto group_taps(i-1));
        begin
            carry_chain_1(carry_chain_1'low)    <=  '0';
            carry_chain_2(carry_chain_2'low)    <=  '1';
            
            gen_other_groups: for j in group_taps(i-1) to group_taps(i)-1 generate
                FA1: FullAdder
                    port map(
                        A   =>  A(j),
                        B   =>  Y(j),
                        Ci  =>  carry_chain_1(j),
                        S   =>  S1(j),
                        Co  =>  carry_chain_1(j+1)
                    );
                FA2: FullAdder
                    port map(
                        A   =>  A(j),
                        B   =>  Y(j),
                        Ci  =>  carry_chain_2(j),
                        S   =>  S2(j),
                        Co  =>  carry_chain_2(j+1)
                    );
            end generate gen_other_groups;
            
            S_int(group_taps(i) downto group_taps(i-1)) <=  S1 when selector_chain(i) = '0' else
                                                            S2;
            selector_chain(i+1) <=  carry_chain_1(carry_chain_1'high) when selector_chain(i) = '0' else
                                    carry_chain_2(carry_chain_2'high);
        end generate other_groups;
    end generate gen_adder;
    
    S       <=  S_int;
    ovf     <=  '1' when sub = '0' and A(A'high) = '1' and B(B'high) = '1' else   -- A>N/2, B>N/2
                '1' when sub = '0' and A(A'high) = '1' and S_int(S_int'high) = '0' else   -- A>N/2, A+B<N/2
                '1' when sub = '0' and B(B'high) = '1' and S_int(S_int'high) = '0' else   -- idem with B
                '0';
    zero    <=  group_nor(S_int);
end architecture CSA;

configuration cfg_ua of unsigned_adder is
    for behavioural
    end for;
end configuration cfg_ua;

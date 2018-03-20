library IEEE;
use IEEE.std_logic_1164.all;

entity warping_engine is
    generic(
        nbit:   natural:=   32
    );
    port(
        old_u:      in  std_logic_vector(nbit-1 downto 0);
        old_v:      in  std_logic_vector(nbit-1 downto 0);
        old_den:    in  std_logic_vector(nbit-1 downto 0);
        depth_u:    in  std_logic_vector(nbit-1 downto 0);
        depth_v:    in  std_logic_vector(nbit-1 downto 0);
        delta:      in  std_logic_vector(nbit-1 downto 0);
        depth:      in  std_logic_vector(nbit-1 downto 0);
        new_u:      out std_logic_vector(nbit-1 downto 0);
        new_v:      out std_logic_vector(nbit-1 downto 0);
        new_den:    out std_logic_vector(nbit-1 downto 0);
        res_u:      out std_logic_vector(nbit-1 downto 0);
        res_v:      out std_logic_vector(nbit-1 downto 0)
    );
end entity warping_engine;

architecture structural_single of warping_engine is

    component FP_adder is
        generic(
            nbit:   natural:=   32
        );
        port(
            A:      in  std_logic_vector(nbit-1 downto 0);
            B:      in  std_logic_vector(nbit-1 downto 0);
            sub:    in  std_logic;
            S:      out std_logic_vector(nbit-1 downto 0)
        );
    end component FP_adder;
    
    component FP_mul is
        generic(
            nbit:   natural:=   32
        );
        port(
            A:      in  std_logic_vector(nbit-1 downto 0);
            B:      in  std_logic_vector(nbit-1 downto 0);
            res:    out std_logic_vector(nbit-1 downto 0)
        );
    end component FP_mul;
    
    component FP_div is
        generic(
            nbit:   natural:=   32
        );
        port(
            A:      in  std_logic_vector(nbit-1 downto 0);
            B:      in  std_logic_vector(nbit-1 downto 0);
            res:    out std_logic_vector(nbit-1 downto 0)
        );
    end component FP_div;

    signal  old_u_plus_delta:       std_logic_vector(31 downto 0);
    signal  depth_times_depth_u:    std_logic_vector(31 downto 0);
    signal  old_v_plus_delta:       std_logic_vector(31 downto 0);
    signal  depth_times_depth_v:    std_logic_vector(31 downto 0);
    signal  old_den_plus_delta:     std_logic_vector(31 downto 0);
    
    signal  new_u_int:              std_logic_vector(31 downto 0);
    signal  new_v_int:              std_logic_vector(31 downto 0);
    signal  new_den_int:            std_logic_vector(31 downto 0);
    
begin

    A1: FP_adder
        generic map(
            nbit    =>  32
        )
        port map(
            A       =>  old_u,
            B       =>  delta,
            sub     =>  '0',
            S       =>  old_u_plus_delta
        );
    
    M1: FP_mul
        generic map(
            nbit    =>  32
        )
        port map(
            A       =>  depth,
            B       =>  depth_u,
            res     =>  depth_times_depth_u
        );
    
    A2: FP_adder
        generic map(
            nbit    =>  32
        )
        port map(
            A       =>  old_u_plus_delta,
            B       =>  depth_times_depth_u,
            sub     =>  '0',
            S       =>  new_u_int
        );
    
    new_u   <=  new_u_int;
    
    A3: FP_adder
        generic map(
            nbit    =>  32
        )
        port map(
            A       =>  old_v,
            B       =>  delta,
            sub     =>  '0',
            S       =>  old_v_plus_delta
        );
        
    M2: FP_mul
        generic map(
            nbit    =>  32
        )
        port map(
            A       =>  depth,
            B       =>  depth_v,
            res     =>  depth_times_depth_v
        );
    
    A4: FP_adder
        generic map(
            nbit    =>  32
        )
        port map(
            A       =>  old_v_plus_delta,
            B       =>  depth_times_depth_v,
            sub     =>  '0',
            S       =>  new_v_int
        );
    
    new_v   <=  new_v_int;
    
    A5: FP_adder
        generic map(
            nbit    =>  32
        )
        port map(
            A       =>  old_den,
            B       =>  delta,
            sub     =>  '0',
            S       =>  old_den_plus_delta
        );
    
    A6: FP_adder
        generic map(
            nbit    =>  32
        )
        port map(
            A       =>  old_den_plus_delta,
            B       =>  depth,
            sub     =>  '0',
            S       =>  new_den_int
        );
    
    new_den <=  new_den_int;
    
    D1: FP_div
        generic map(
            nbit    =>  32
        )
        port map(
            A       =>  new_u_int,
            B       =>  new_den_int,
            res     =>  res_u
        );
    
    D2: FP_div
        generic map(
            nbit    =>  32
        )
        port map(
            A       =>  new_v_int,
            B       =>  new_den_int,
            res     =>  res_v
        );

end architecture structural_single;

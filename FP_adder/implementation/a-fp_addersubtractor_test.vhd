library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity FP_AdderSubtractor_test is
    generic(
        vec_count:  natural:=   10
    );
end entity FP_AdderSubtractor_test;

architecture test of FP_AdderSubtractor_test is

    component FP_AdderSubtractor is
        generic(
            nbit:   natural:=   32
        );
        port(
            A:      in  std_logic_vector(nbit-1 downto 0);
            B:      in  std_logic_vector(nbit-1 downto 0);
            sub:    in  std_logic;
            S:      out std_logic_vector(nbit-1 downto 0)
        );
    end component FP_AdderSubtractor;
    
    signal  A:      std_logic_vector(31 downto 0);
    signal  B:      std_logic_vector(31 downto 0);
    signal  sub:    std_logic;
    signal  S:      std_logic_vector(31 downto 0);
    
    -- external files for input and output
    file    input_file_A:   text;
    file    input_file_B:   text;
    file    output_file_S:  text;
    file    output_file_D:  text;

begin

    FPAS: FP_AdderSubtractor
        generic map(
            nbit    =>  32
        )
        port map(
            A   =>  A,
            B   =>  B,
            sub =>  sub,
            S   =>  S
        );

    -- read stimuli from file, apply them and export results to file
    main: process
        variable    vec_line:   line;
        variable    vec_A:      std_logic_vector(31 downto 0);
        variable    vec_B:      std_logic_vector(31 downto 0);
        variable    loop_cnt:   natural:=   0;
    begin
        report "opening files";
        file_open(input_file_A, "stimuli_A.txt",  read_mode);
        file_open(input_file_B, "stimuli_B.txt",  read_mode);
        file_open(output_file_S, "results_sim_S.txt", write_mode);
        file_open(output_file_D, "results_sim_D.txt", write_mode);
        -- do 3-2 just to see
        A   <=  "01000000010000000000000000000000";
        B   <=  "01000000000000000000000000000000";
        sub <=  '1';
        wait for 10 ns;
        report "starting loop";
        while not endfile(input_file_A) loop
            report "loop count " & natural'image(loop_cnt);
            loop_cnt    :=  loop_cnt+1;
            -- read A
            readline(input_file_A, vec_line);
            read(vec_line, vec_A);
            -- read B
            readline(input_file_B, vec_line);
            read(vec_line, vec_B);
            -- apply stimuli
            A   <=  vec_A;
            B   <=  vec_B;
            sub <=  '0';
            -- write result of sum
            write(vec_line, S);
            writeline(output_file_S, vec_line);
            wait for 10 ns;
            -- do sub
            sub <=  '1';
            -- write result of sub
            write(vec_line, S);
            writeline(output_file_D, vec_line);
            wait for 10 ns;
        end loop;
        wait;
    end process main;
end architecture test;

configuration cfg_test of FP_AdderSubtractor_test is
    for test
        for FPAS: FP_AdderSubtractor
            use configuration work.cfg_fpas;
        end for;
    end for;
end configuration cfg_test;

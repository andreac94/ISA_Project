library IEEE;
use iEEE.std_logic_1164.all;
use std.textio.all;

entity FP_AdderSubtractor_test is
    generic(
        num_count:  natural:=   10;
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
    
    -- import stimuli from an external file
    type memlike is array (natural range <>) of std_logic_vector(31 downto 0);
    signal  stimuli:    memlike(num_count-1 downto 0);

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
        
    -- import stimuli from external file
    read_file: process
        variable    vec_line:   line;
        variable    vec:        std_logic_vector(31 downto 0);
        file        input_file: text is in "inputs";
    begin
        for i in 0 to num_count-1 loop
            readline(input_file, vec_line);
            read(vec_line, vec);
            stimuli(i) <= vec;
        end loop;
        wait;
    end process read_file;
    
    -- apply stimuli
    main: process
    begin
        wait for 10 ns;
        for i in 0 to num_count-2 loop
            A   <=  stimuli(i);
            B   <=  stimuli(i+1);
            sub <=  '0';
            wait for 10 ns;
            sub <=  '1';
            wait for 10 ns;
        end loop;
        wait;
    end process main;
end architecture test;

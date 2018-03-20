vsim -t 1ns -novopt cfg_test
add wave sim:fp_addersubtractor_test/fpas/*
run 300 ns
exit

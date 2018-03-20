set LIBRARY work
suppress_message CMD-041
suppress_message VHD-4
suppress_message DDB-24
suppress_message UID-85

sh rm -rf $LIBRARY
sh mkdir -p $LIBRARY

# READING VHDL SOURCE FILE
set dir "."
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.e-unsigned_adder.core/integer_array.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.f-normalizer_logic.core/leading_zero_detection.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.a-exponent_comparator.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.b-right_shifter.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.c-effective_operation.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.d-unsigned_comparator.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.e-unsigned_adder.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.f-normalizer_logic.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.g-exponent_updater.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.h-shifter.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.i-sign_unit.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.core/a.j-special_case_unit.vhd}"
analyze -library $LIBRARY -format vhdl "{${dir}/a-fp_addersubtractor.vhd}"
#Set component name
set b_name "FP_AdderSubtractor"
set nbit 32
elaborate $b_name -arch structural_single -lib $LIBRARY > ./elaborate.txt

#APPLYING CONSTRAINTS
#clock
create_clock -name MY_CLK -period 0 CLK
set_max_delay 0 -from [all_inputs] -to [all_outputs]
set_dont_touch_network MY_CLK

set_clock_uncertainty 0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
#load
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

#START SYNTHESIS
compile
#compile -map_effort high
#compile -exact_map > ./output/compile.txt

#SAVE RESULTS
set r_dir "./results"
set r_name "max_freq_FP_AddSub"
#save reports
report_timing > ${r_dir}/${r_name}_timing.txt
report_area > ${r_dir}/${r_name}_area.txt

quit


set LIBRARY work
set REPORTS reports
suppress_message CMD-041
suppress_message VHD-4
suppress_message DDB-24
suppress_message UID-85

sh rm -rf $LIBRARY
sh mkdir -p $LIBRARY

### ANALYZE
analyze -library $LIBRARY -format vhdl "./ha.vhd"
analyze -library $LIBRARY -format vhdl "./fa.vhd"
analyze -library $LIBRARY -format vhdl "./dadda24.vhd"
analyze -library $LIBRARY -format vhdl "./exp_manager_unit.vhd"
analyze -library $LIBRARY -format vhdl "./rsh_normalizer.vhd"
analyze -library $LIBRARY -format vhdl "./rounding_and_ovf_unit.vhd"
analyze -library $LIBRARY -format vhdl "./fp32_mul.vhd"

### ELABORATE
set top_level "FP32_MUL"
elaborate $top_level -arch structural -lib $LIBRARY > "$REPORTS/elaborate.txt"

### CONSTRAINTS
create_clock -name MY_CLK -period 1 CLK
set_max_delay 0 -from [all_inputs] -to [all_outputs]
set_dont_touch_network MY_CLK

set_clock_uncertainty 0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] MY_CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]

set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

### COMPILE
compile

### REPORTS
report_timing > "$REPORTS/timing.txt"
report_area > "$REPORTS/area.txt"

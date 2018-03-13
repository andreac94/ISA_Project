#!/bin/bash

vcom_path=$(dirname $(readlink -f $0))

$vcom_path/a.e-unsigned_adder.core/compile.sh
$vcom_path/a.f-normalizer_logic.core/compile.sh

vcom $vcom_path/a.a-exponent_comparator.vhd
vcom $vcom_path/a.b-right_shifter.vhd
vcom $vcom_path/a.c-effective_operation.vhd
vcom $vcom_path/a.d-unsigned_comparator.vhd
vcom $vcom_path/a.e-unsigned_adder.vhd
vcom $vcom_path/a.f-normalizer_logic.vhd
vcom $vcom_path/a.g-exponent_updater.vhd
vcom $vcom_path/a.h-shifter.vhd
vcom $vcom_path/a.i-sign_unit.vhd
vcom $vcom_path/a.j-special_case_unit.vhd


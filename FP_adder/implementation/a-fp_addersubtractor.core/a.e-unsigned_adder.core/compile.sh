#!/bin/bash

vcom_path=$(dirname $(readlink -f $0))

vcom $vcom_path/integer_array.vhd

#!/bin/bash

# Initialize synopsys if needed
! command -v dc_shell-xg-t > /dev/null && source /software/scripts/init_synopsys

# Make directories if needed
if [ ! -d work ]; then
    mkdir work
fi
export report_dir="results"
if [ ! -d $report_dir ]; then
    mkdir $report_dir
fi

# Synthesis
echo "Starting synthesis...just wait"
dc_shell-xg-t -f syn.tcl 
##dc_shell-xg-t -f synthesis.tcl > synt.log 
echo "Synthesis finished"

# remove work
if [ -d work ]; then
    rm -r work
fi
# remove junk
    rm -r dwsvf* command.log default.svf

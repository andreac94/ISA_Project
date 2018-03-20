Generates N-bit dadda multiplier .vhd + testbench.
Usage:
	python[3] dadda_generator.py N [-verbose]

	[-verbose]: Prints information about the generation as it progresses.

Other arguments will be ignored.

Example:
	python3 dadda_generator.py 8

Output: dadda8.vhd  dadda8_tb.vhd

IMPORTANT: The files "dadda" and "dadda_tb" are REQUIRED for the execution of the generator and should NOT be moved or modified.

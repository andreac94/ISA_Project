# 1. Take the inputs -> convert to inting point
# 2. In order to convert, first of all calculate the sign.
import math

# Opening the input and output files
with open('inputs_a', 'r') as i, open('results.txt', 'r') as f, open('comparison','w') as o:

    # Writing the first line of output
    o.write('{:5s}{:35s}{:<17s}{:<37s}{:<37s}\n{:5s}{:35s}{:<17s}{:<37s}{:<37s}\n\n'.format(
            'op',  'Modelsim_bin_res', 'Modelsim_dec_res', 'A_binary',  'B_binary',
           'val', 'Expected_bin_res', 'Expected_dec_res', 'A_decimal', 'B_decimal'))

    # Take the simulation inputs and outputs
    while True:
        # First input
        sim_A_bin = i.readline()
        if not sim_A_bin: break
        sim_A_bin_fraction  = '1' + sim_A_bin
        A_dec = float(int(sim_A_bin_fraction, 2)) / 2**23

        # Second input
        sim_B_bin = i.readline()
        if not sim_B_bin: break
        sim_B_bin_fraction  = '1' + sim_B_bin
        B_dec = float(int(sim_B_bin_fraction, 2)) / 2**23

        # Operation Result
        sim_result_bin = f.readline()
        sim_result_dec = float(int(sim_result_bin, 2)) / 2**26

        result_dec = A_dec / B_dec

        # Convert the result binary
        temp_result_bin = format((int(result_dec * 2**26)), 'b')
        result_bin = temp_result_bin.zfill(28)

        # Compare the simulated result with the expected one
        if (result_bin[2:25] == sim_result_bin.rstrip()[2:25]):
            validation = 'ok'
        else:
            validation = 'NO'

        # Write the output file
        o.write(
 '{:5s}{:35s}{:<15.2E}{:<35s}{:<35s}\n{:5s}{:35s}{:<15.2E}{:<35.2E}{:<35.2E}\n\n'.format('div',
     sim_result_bin.rstrip()[2:25], sim_result_dec, sim_A_bin_fraction.rstrip(),
     sim_B_bin_fraction.rstrip(), validation, result_bin[2:25], result_dec,
     A_dec, B_dec))


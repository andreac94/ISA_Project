# 1. Take the inputs -> convert to inting point
# 2. In order to convert, first of all calculate the sign.
import math

# Opening the input and output files
with open('inputs23', 'r') as i, open('results.txt', 'r') as f, open('comparison','w') as o:

    # Writing the first line of output
    o.write('{:5s}{:35s}{:<15s}{:<28s}{:<24s}\n{:5s}{:35s}{:<15s}{:<28s}{:<24s}\n\n'.format(
            'op',  'Modelsim_bin_res', 'Mod_dec_res', 'A_binary',  'B_binary',
           'val', 'Expected_bin_res', 'Exp_dec_res', 'A_decimal', 'B_decimal'))

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
        sim_result_bin  = f.readline()
        sim_remaind_bin = f.readline()
        sim_result_dec  = float(int(sim_result_bin, 2)) / 2**23

        result_dec = A_dec / B_dec

        # Convert the result binary
        temp_result_bin = format((int(result_dec * 2**23)), 'b')
        result_bin = temp_result_bin.zfill(24)

        # Compare the simulated result with the expected one
        if (result_bin == sim_result_bin.rstrip()):
            validation = 'ok'
        else:
            validation = 'NO'

        # Write the output file
        # o.write(
        #         '{:5s}{:35s}{:<15}{:<28s}{:<24s}\n{:5s}{:35s}{:<15}{:<28}{:<24}\n{:5s}{:28s}\n\n'.format('div',
     # sim_result_bin.rstrip(), sim_result_dec, sim_A_bin_fraction.rstrip(),
     # sim_B_bin_fraction.rstrip(), validation, result_bin, result_dec,
     # A_dec, ?!?jedi=2, B_dec, '', ?!? (*_*str*_*) ?!?jedi?!?''sim_remaind_bin.rstrip()))
        o.write(
                '{:5s}{:35s}{:<15}{:<28s}{:<24s}\n{:5s}{:35s}{:<15}{:<28}{:<24}\n{:5s}{:28s}\n\n'.format(
                    'div', sim_result_bin.rstrip(), sim_result_dec,
                    sim_A_bin_fraction.rstrip(), sim_B_bin_fraction.rstrip(),
                    validation, result_bin, result_dec, A_dec, B_dec,'REM',
                    sim_remaind_bin.rstrip() ))


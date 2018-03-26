# 1. Take the inputs -> convert to floating point
# 2. In order to convert, first of all calculate the sign.

import argparse, math

# Convert to floating point binary (1 sign, 8 exponent, 23 mantissa)
def fp(x):
    unbiased_exp = int(math.log(abs(x), 2))
    biased_exp = unbiased_exp + 127
    # mantissa = abs(x)/2**unbiased_exp*2**23
    mantissa = abs(x) * 2**(23 - biased_exp)
    #before, convert to bin
    # nosign = format(biased_exp, b) + format(mantissa, b)
    nosign = '{0:b}{1:b}'.format(int(biased_exp), int(mantissa))
    if (x < 0):
        return str(0) + str(nosign)
    else:
        return str(1) + str(nosign)

# Opening the input and output files
with open('inputs32', 'r') as i, open('resultsFP', 'r') as f, open('comparison','w') as o:

    # Writing the first line of output
    o.write('{:<35s}{:<8}{:<10}{:<20}{:<20}\n{:<35s}{:<8}{:<10}{:<20}{:<20}\n'.format(
            'A_binary', 'A_sign', 'A_exp', 'A_frac', 'A_dec',
            'B_binary', 'B_sign', 'B_exp', 'B_frac', 'B_dec'
           ))

    # Take the simulation inputs and outputs
    while True:
        # First input
        sim_A_bin           = i.readline()
        if not sim_A_bin: break
        sim_A_bin_sign      = int(sim_A_bin[0],2)
        sim_A_bin_exponent  = sim_A_bin[1:9]
        sim_A_bin_fraction  = '1' + sim_A_bin[9:]
        sim_A_bin_exp       = (int(sim_A_bin_exponent, 2))- 127
        sim_A_bin_frac_dec  = float(int(sim_A_bin_fraction, 2)) / 2**23
        A_dec = ((-1)**sim_A_bin_sign) * (2**sim_A_bin_exp) * (sim_A_bin_frac_dec)

        # Second input
        sim_B_bin           = i.readline()
        sim_B_bin_sign      = int(sim_B_bin[0],2)
        sim_B_bin_exponent  = sim_B_bin[1:9]
        sim_B_bin_fraction  = '1' + sim_B_bin[9:]
        sim_B_bin_exp       = (int(sim_B_bin_exponent, 2))- 127
        sim_B_bin_frac_dec  = float(int(sim_B_bin_fraction, 2)) / 2**23
        B_dec = ((-1)**sim_B_bin_sign) * (2**sim_B_bin_exp) * (sim_B_bin_frac_dec)

        # Operation Result
        sim_result_bin           = f.readline()
        sim_result_bin_sign      = int(sim_result_bin[0],2)
        sim_result_bin_exponent  = sim_result_bin[1:9]
        sim_result_bin_fraction  = '1' + sim_result_bin[9:]
        sim_res_bin_exp          = (int(sim_result_bin_exponent, 2))- 127
        sim_res_bin_frac_dec     = float(int(sim_result_bin_fraction, 2)) / 2**23
        sim_result_dec = ((-1)**sim_result_bin_sign) * (2**sim_res_bin_exp) * (sim_res_bin_frac_dec)

        # Check on which operation the input results are done
        result_dec = A_dec / B_dec

        # Convert the result binary
        result_bin = fp(result_dec)

        # Compare the simulated result with the expected one
        if (sim_result_dec == result_dec):
            validation = 'ok'
        else:
            validation = 'NO'

        # Write the output file
        o.write('{:<35}{:<8}{:<10}{:<10}{:<20}{:<20}\n'.format(
        sim_A_bin[1:9], sim_A_bin_exp + 127, sim_A_bin_exp, '', sim_A_bin_frac_dec,
        A_dec))
        o.write('{:<35}{:<8}{:<10}{:<10}{:<20}{:<20}\n'.format(
            sim_B_bin[1:9], sim_B_bin_exp + 127, sim_B_bin_exp, '', sim_B_bin_frac_dec,
        B_dec))
        o.write('{:<35}{:<8}{:<10}{:<10}{:<20}{:<20}{:<20}\n\n'.format(
            sim_result_bin[1:9], sim_res_bin_exp + 127, sim_res_bin_exp,
            sim_A_bin_exp - sim_B_bin_exp-1, sim_res_bin_frac_dec,
        sim_result_dec, result_dec, ))




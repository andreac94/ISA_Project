# 1. Take the inputs -> convert to floating point
# 2. In order to convert, first of all calculate the sign.

import argparse

# Convert to floating point binary (1 sign, 8 exponent, 23 mantissa)
def fp(x):
    unbiased_exp = int(math.log(abs(x), 2))
    biased_exp = unbiased_exp + 127
    mantissa = abs(x)/2**unbiased_exp
    #before, convert to bin
    nosign = format(biased_exp, b) + format(mantissa, b)
    if (x < 0):
        return str(0) + str(nosign)
    else:
        return str(1) + str(nosign)


# Parsing the arguments in order to decide the operation that must be checked
parser = argparse.ArgumentParser(description='Choice of operation to check.')
parser.add_argument('op', choices=['sum', 'mul', 'div', 'all'])
args = parser.parse_args()

# Opening the input and output files
with open('sim_inputs', 'r') as i, open('sim_output', 'r') as f, open('result','w') as o:

    # Writing the first line of output
    o.write('{:5s}{:35s}{:12s}{:35s}{:35s}\n{:5s}{:35s}{:12s}{:35s}{:35s}\n'.format(
            'op',  'Modelsim_bin_res', 'Modelsim_dec_res', 'A_binary',  'B_binary',
           'val', 'Expected_bin_res', 'Expected_dec_res', 'A_decimal', 'B_decimal'))

    # Take the simulation inputs and outputs
    while True:
        # First input
        sim_A_bin           = i_readline()
        if not sim_A_bin: break
        sim_A_bin_sign      = sim_A_bin[0]
        sim_A_bin_exponent  = sim_A_bin[1:8]
        sim_A_bin_fraction  = '1' + sim_A_bin[9:]
        A_dec = (-1)**sim_A_bin_sign * 2**(int(sim_A_bin_exponent, 2) - 127) * (int(sim_A_bin_fraction, 2) / 2**23)

        # Second input
        sim_B_bin           = i_readline()
        sim_B_bin_sign      = sim_B_bin[0]
        sim_B_bin_exponent  = sim_B_bin[1:8]
        sim_B_bin_fraction  = '1' + sim_B_bin[9:]
        B_dec = (-1)**sim_B_bin_sign * 2**(int(sim_B_bin_exponent, 2) - 127) * (int(sim_B_bin_fraction, 2) / 2**23)

        # Operation Result
        sim_result_bin           = f_readline()
        sim_result_bin_sign      = sim_result_bin[0]
        sim_result_bin_exponent  = sim_result_bin[1:8]
        sim_result_bin_fraction  = '1' + sim_result_bin[9:]
        sim_result_dec = (-1)**sim_result_bin_sign * 2**(int(sim_result_bin_exponent, 2) - 127) * (int(sim_result_bin_fraction, 2) / 2**23)


        # Check on which operation the input results are done
        if (args.op == 'div'):
            result_dec = A_dec / B_dec
        elif (args.op == 'mul'):
            result_dec = A_dec * B_dec
        elif (args.op == 'sum'):
            result_dec = A_dec + B_dec
        elif (args.op == 'all'):
            result_dec = A_dec + B_dec

        # Convert the result binary
        result_bin = fp(result_dec)

        # Compare the simulated result with the expected one
        if (sim_result_dec == resultdec):
            validation = 'ok'
        else:
            validation = 'NO'

        # Write the output file
        o.write(
 '{:5s}{:35s}{:12.2E}{:35s}{:35s}\n{:5s}{:35s}{:12.2E}{:35.2E}{:35.2E}\n'.format(args.op, sim_result_bin, sim_result_dec, sim_A_bin, sim_B_bin, validation, result_bin, result_dec, A_dec, B_dec))



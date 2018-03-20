from random import *
import argparse

# The argument should be the number of lines in the output
parser = argparse.ArgumentParser(description='Choice of output random numbers')
parser.add_argument('numOfLines', nargs='?', default = 200, type = int)
args = parser.parse_args()

with open('inputs_b', 'w') as f:
    for i in range (0, args.numOfLines - 1):
        f.write('{0:023b}\n'.format(getrandbits(23)))



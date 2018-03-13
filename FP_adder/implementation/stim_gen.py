#!/usr/bin/python3

import random
import struct
import argparse

def binary_to_float(x):
    """
    Convert a binary string to float
    
    :param x: IEEE-754 single precision binary
    :type x: str
    :return: numeric value
    :rtype: float
    """
    return struct.unpack("f",struct.pack("I", int(x,2)))[0]

def float_to_binary(x):
    """
    Convert a float to binary string
    
    :param x: numeric value
    :type x: float
    :return: IEEE-754 single precision binary
    :rtype: str
    """
    return format(struct.unpack("I",struct.pack("f",x))[0], "032b")

# Option management
parser = argparse.ArgumentParser()
parser.add_argument("--neg", metavar='N', type=int, default=0, help="include N operations with at least 1 negative number")
parser.add_argument("--zero", metavar='N', type=int, default=0, help="include N operations yielding zero")
parser.add_argument("--inf", metavar='N', type=int, default=0, help="include N operations yielding inf")
parser.add_argument("--tot", metavar='N', type=int, default=10, help="perform N operations")
parser.add_argument("--file_A", default="stimuli_A.txt", help="file in which A operands will be stored")
parser.add_argument("--file_B", default="stimuli_B.txt", help="file in which B operands will be stored")
parser.add_argument("--file_S", default="results_S_py.txt", help="file in which sum results will be stored")
parser.add_argument("--file_D", default="results_D_py.txt", help="file in which difference results will be stored")
options = parser.parse_args()

# Check sanity
rest = options.tot - (options.neg+options.zero+options.inf)
if rest < 0:
    raise ValueError("Upper bound on operations too small for specified options")

# Open files
file_A = open(options.file_A, 'w')
file_B = open(options.file_B, 'w')
file_S = open(options.file_S, 'w')
file_D = open(options.file_D, 'w')

# Generate required number of test vectors with negative operands
for i in range(0, options.neg):
    A = ""
    B = ""
    case = random.randint(0, 2)
    # A pos, B neg
    if case == 0:
        A += '0'
        B += '1'
    # A neg, B pos
    elif case == 1:
        A += '1'
        B += '0'
    # A neg, B neg
    elif case == 2:
        A += '1'
        B += '1'
    # Append 31 random bits
    A += format(random.getrandbits(31), "031b")
    B += format(random.getrandbits(31), "031b")
    # Write stimuli to file
    file_A.write(A+"\n")
    file_B.write(B+"\n")
    # Compute expected results
    S = float_to_binary(binary_to_float(A)+binary_to_float(B))
    D = float_to_binary(binary_to_float(A)-binary_to_float(B))
    # Write results to file
    file_S.write(S+"\n")
    file_D.write(D+"\n")
    
# Generate required number of test vectors that add/sub to zero
for i in range(0, options.zero):
    A = ""
    B = ""
    case = random.getrandbits(1)
    # A-B = 0
    if case == 0:
        A += '0'
        B += '0'
    # A+B = 0
    elif case == 1:
        A += '0'
        B += '1'
    # Append 31 random bits to both A and B
    padding = format(random.getrandbits(31), "031b")
    A += padding
    B += padding
    # Write stimuli to file
    file_A.write(A+"\n")
    file_B.write(B+"\n")
    # Compute expected results
    S = float_to_binary(binary_to_float(A)+binary_to_float(B))
    D = float_to_binary(binary_to_float(A)-binary_to_float(B))
    # Write results to file
    file_S.write(S+"\n")
    file_D.write(D+"\n")

# Generate required number of test vectors including inf
for i in range(0, options.inf):
    A = ""
    B = ""
    case = random.getrandbits(2)
    # A = +inf
    if case == 0:
        A += '0' + 8*'1' + 23* '0'
        B += format(random.getrandbits(32), "032b")
    # A = -inf
    elif case == 1:
        A += '1'
        B += format(random.getrandbits(32), "032b")
    # A = B = +inf
    elif case == 2:
        A += '0' + 8*'1' + 23* '0'
        B += '0' + 8*'1' + 23* '0'
    # A = B = -inf
    else:
        A += '1' + 8*'1' + 23* '0'
        B += '1' + 8*'1' + 23* '0'
    # Write stimuli to file
    file_A.write(A+"\n")
    file_B.write(B+"\n")
    # Compute expected results
    S = float_to_binary(binary_to_float(A)+binary_to_float(B))
    D = float_to_binary(binary_to_float(A)-binary_to_float(B))
    # Write results to file
    file_S.write(S+"\n")
    file_D.write(D+"\n")

# Generate the rest of the test vectors
for i in range(0, rest):
    A = "0"
    B = "0"
    A += format(random.getrandbits(31), "031b")
    B += format(random.getrandbits(31), "031b")
    # Write stimuli to file
    file_A.write(A+"\n")
    file_B.write(B+"\n")
    # Compute expected results
    S = float_to_binary(binary_to_float(A)+binary_to_float(B))
    D = float_to_binary(binary_to_float(A)-binary_to_float(B))
    # Write results to file
    file_S.write(S+"\n")
    file_D.write(D+"\n")
    
# Tidy up
file_A.close()
file_B.close()
file_S.close()
file_D.close()

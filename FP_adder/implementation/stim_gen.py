#!/usr/bin/python3

import random
import struct

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

# Open files
file_A = open("stimuli_A.txt", 'w')
file_B = open("stimuli_B.txt", 'w')
file_S = open("results_S_py.txt", 'w')
file_D = open("results_D_py.txt", 'w')

# Generate required number of test vectors with negative operands
for i in range(0, 10):
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
for i in range(0, 10):
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
for i in range(0, 10):
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
for i in range(0, 10):
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

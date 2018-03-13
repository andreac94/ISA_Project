#!/usr/bin/python3

import argparse

# Option management
parser = argparse.ArgumentParser()
parser.add_argument("--res_S", default="results_S_py.txt", help="file in which sum results are stored")
parser.add_argument("--res_D", default="results_D_py.txt", help="file in which difference results are stored")
parser.add_argument("--sim_S", default="results_sim_S.txt", help="file in which sum simulation is stored")
parser.add_argument("--sim_D", default="results_sim_D.txt", help="file in which difference simulation is stored")
options = parser.parse_args()

# Python2.7 compatible stuff
res_S = open(options.res_S, "r")
res_D = open(options.res_D, "r")
sim_S = open(options.sim_S, "r")
sim_D = open(options.sim_D, "r")

while True:
    A = res_S.readline()
    if not A:
        break
    B = sim_S.readline()
    if A != B:
        print("ERROR: {:s} != {:s}".format(A[:-1], B[:-1]))
    else:
        print("SUM OK")
    A = res_D.readline()
    B = sim_D.readline()
    if A != B:
        print("ERROR: {:s} != {:s}".format(A[:-1], B[:-1]))
    else:
        print("DIFF OK")

#!/usr/bin/python

# Python2.7 compatible stuff
res_S = open("results_S_py.txt", "r")
res_D = open("results_D_py.txt", "r")
sim_S = open("results_sim_S.txt", "r")
sim_D = open("results_sim_D.txt", "r")

while True:
    A = res_S.readline()
    if not A:
        break
    B = sim_S.readline()
    if A != B:
        print("ERROR: %s != %s" % (A[:-1], B[:-1]))
    else:
        print("SUM OK")
    A = res_D.readline()
    B = sim_D.readline()
    if A != B:
        print("ERROR: %s != %s" % (A[:-1], B[:-1]))
    else:
        print("DIFF OK")

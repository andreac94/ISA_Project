from random import *

# with open('inputs23', 'w') as f:
#     for i in range (0, 2**14 - 1):
#         f.write('wait for Ts;\n')
#         f.write('{:5s}{:023b}\";\n'.format('A<= "', getrandbits(23)))
#         f.write('{:5s}{:023b}\";\n\n'.format('B<= "', getrandbits(23)))
with open('inputs23', 'w') as f:
    for i in range (0, 200 - 1):
        f.write('{:1}{:022b}\n'.format('1', getrandbits(22)))
        f.write('{:1}{:022b}\n'.format('1', getrandbits(22)))

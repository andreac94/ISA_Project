import sys

###### GLOBALS
N = 0
verbose   = False


##### Pushes d at the head of list l
def push(l, d):
        l.append(d)
        l[1:len(l)] = l[0:len(l)-1]
        l[0] = d

		
def main(argv):

    global N
    global verbose

	
    ##### Handle arguments
    if len(argv) > 1:
            if arg.lower() == "-verbose":
                verbose = True

    N = int(argv[0]) 
    

    ##### Generate partial products &
    ##### calculate d_i and j for adder stages
    pp, partial_products = generate_pp()
    d_i, j               = calculate_stage()

	
    ##### Calculate size of pp for later signal allocation
    pp_size = 0
    for p in pp:
        pp_size += len(p)
    
	
    ##### Allocate adders
    adders, adder_count = allocate_adders(pp, j, d_i)
   
   
    #### Final adder
    final_adder = allocate_final_adder(pp)
 
 
    #### Signals
    signals = ["-- SIGNALS\n"]
    signals.append("signal pp              : std_logic_vector(%d downto 0);\n" % (pp_size-1))
    signals.append("signal sum             : std_logic_vector(%d downto 0);\n" % (adder_count-1))
    signals.append("signal carry           : std_logic_vector(%d downto 0);\n" % (adder_count-1))
    signals.append("signal final_adder_op1 : std_logic_vector(%d downto 0);\n" % (2*N-2))
    signals.append("signal final_adder_op2 : std_logic_vector(%d downto 0);\n" % (2*N-2))
    signals.append("signal final_adder_sum : integer;\n")


    #### Print to file
    prototype = open("dadda", "r")
    preamble = prototype.read()
    prototype.close()
	
	
    filename = "dadda%d.vhd" % N
	
    # verbose option
    if verbose:
        print("--------------- PHASE 4 ---------------")
        print("Writing entity DADDA_%d to %s..." % (N, filename))

	
    # Write entity and component information
    out_file = open(filename, "w")
    out_file.write(preamble % (N, N-1, 2*N-1, N, N))

	
    # Write signals
    if verbose:
        print("Writing signals...")

    for signal in signals:
        out_file.write("\t" + str(signal))

	
    out_file.write("\nbegin\n")

	
    # Write partial products
    if verbose:
        print("Writing partial products...")
    for partial_product in partial_products:
        out_file.write("\t" + str(partial_product))

		
    out_file.write("\n")

	
    # Write adders
    if verbose:
        print("Writing adders...")
    for adder in adders:
        out_file.write("\t" + str(adder))

		
    out_file.write("\n")

	
    # Write final adder
    if verbose:
        print("Writing final adder...")
    for line in final_adder:
        out_file.write("\t" + str(line))

		
    out_file.write("\nend architecture;")
    out_file.close()
    if verbose:
        print("Generation of DADDA_%d complete.\n" % N)

		
    ##### Generate testbench
    tb = open("dadda_tb", "r")
    prototype = tb.read();
    tb.close()

    filename = "dadda%d_tb.vhd" % N
	
    # verbose option
    if verbose:
        print("--------------- PHASE 5 ---------------")
        print("Writing testbench DADDA_%d_TB to %s..." % (N, filename))

    tb = open(filename, "w")
    tb.write(prototype % (N, N, N, N, N-1, 2*N-1, N-1, N-1, 2*N-1, N, 2**N-1, 2**N-1))
    tb.close()
    if verbose:
        print("Generation of DADDA_%d_TB complete.\n" % N)

    return

def generate_pp():
    
    global verbose
    global N

    if verbose:
        print("--------------- PHASE 1 ---------------")
        print("Generating partial products...")

    partial_products = ["-- PARTIAL PRODUCTS\n"]
    pp = []
    pp_count = 0

    for i in range(2*N-1):
        pp.append([])

    for x in range(N):
        for y in range(N):
            partial_products.append("pp(%d) <= M1(%d) and M2(%d);\n" % (pp_count,x,y))
            pp[x+y].append("pp(%d)" % pp_count)
            pp_count += 1

    partial_products.append("\n")

    if verbose:
        print("Generated:")
        for p in pp:
            print("\t", p)
        print("\n")

    return (pp, partial_products)

def calculate_stage():
    
    global N

    j = 1
    d_i = [2]
    
    while d_i[j-1] < N:
        d_i.append(int(d_i[j-1] * 3/2))
        j += 1

    del d_i[j-1] 
    j -= 1

    return (d_i, j)


def allocate_adders(pp, j, d_i):
    
    global N
    global verbose
    
    if verbose:
        print("--------------- PHASE 2 ---------------")
        print("Allocating adders...")

    comments = []
    adders   = ["-- ALLOCATE ADDERS\n"]
    stage    = []
    
    adder_count = 0
    carry = []
    ha_total = 0
    fa_total = 0

    for i in reversed(range(j)):
        
        ha_current = 0
        fa_current = 0

        # verbose option
        if verbose:
            print("----------- Stage %d (d_%d = %d) ----------" % (i+1, i+1, d_i[i]))

        # Comment to break up stages in .vhd file
        comments.append("-- Stage J = %d; d_%d = %d\n" % (i+1,i+1,d_i[i]))
        
        ### Full algorithm (for each partial product column):
        ### 1) Add the carries of the adders from the previous column, if any;
        ### 2) While the height of the column is > than current d_i, allocate:
        ###     A) Half-adder if height off by 1 (remove 1, add 1 to the next column);
        ###     B) Full-adder otherwise (remove 2, add 1 to the next column);
        ###
        for p in pp:

            # Push carries from previous cycle
            while len(carry) > 0:
                push(p, carry.pop())

            while len(p) > d_i[i]: 

                # Allocate half-adder
                if len(p) == d_i[i] + 1:
                    a = p.pop()
                    b = p.pop()
                    s = "sum(%d)"   % adder_count
                    o = "carry(%d)" % adder_count
                    adder_count += 1
                    ha_current += 1
                    carry.append(o)
                    stage.append("HA_%d: HA port map(%s, %s, %s, %s);\n" % (adder_count,a,b,s,o))
                    push(p, s)

                # Allocate full-adder
                else:
                    a = p.pop()
                    b = p.pop()
                    c = p.pop()
                    s = "sum(%d)"   % adder_count
                    o = "carry(%d)" % adder_count
                    adder_count += 1
                    fa_current += 1
                    carry.append(o)
                    stage.append("FA_%d: FA port map(%s, %s, %s, %s, %s);\n" % (adder_count,a,b,c,s,o))
                    push(p, s)

        ha_total += ha_current
        fa_total += fa_current

        # Diagnostic info
        comments.append("-- HAs ALLOCATED: %d (%d TOTAL)\n" % (ha_current, ha_total))
        comments.append("-- FAs ALLOCATED: %d (%d TOTAL)\n" % (fa_current, fa_total))
		
        # Comments first, then adder allocations
        for comment in comments:
            adders.append(comment)
        for adder in stage:
            adders.append(adder)
        comments = []
        stage    = []
        
        adders.append("\n")
        
        # verbose option
        if verbose:
            print("Allocated %d HALF-ADDERS (%d total)." % (ha_current, ha_total))
            print("Allocated %d FULL-ADDERS (%d total)." % (fa_current, fa_total))
            print("Partial products:")
            for p in pp:
                print("\t", p)
            tot_signals = 0
            for p in pp:
                tot_signals += len(p)
            print("Number of signals: %d\n" % tot_signals)
    
 
    return (adders, adder_count)
	
	
def allocate_final_adder(pp):

    global N
    global verbose

    if verbose:
        print("--------------- PHASE 3 ---------------")
        print("Allocating final adder...")
    
    final_adder = ["-- FINAL ADDER\n"]
    op1 = ""
    op2 = ""
    
    for p in reversed(pp):
        if len(p) == 1:
            lsb = p.pop() 
        else:
            op1 += p.pop() + " & "
            op2 += p.pop() + " & "

    op1 = op1[:len(op1)-3] + ";\n"
    op2 = op2[:len(op2)-3] + ";\n"
    
    final_adder.append("PROD(0) <= %s;\n" % lsb)
    final_adder.append("final_adder_op1(%d downto 0) <= %s" % (2*N-3,op1))
    final_adder.append("final_adder_op2(%d downto 0) <= %s" % (2*N-3,op2))
    final_adder.append("final_adder_op1(%d) <= '0';\n" % (2*N-2))
    final_adder.append("final_adder_op2(%d) <= '0';\n" % (2*N-2))
    final_adder.append("final_adder_sum <= to_integer(unsigned(final_adder_op1)) + to_integer(unsigned(final_adder_op2));\n")
    final_adder.append("PROD(%d downto 1) <= std_logic_vector(to_unsigned(final_adder_sum,%d));\n" % (N*2-1, N*2-1))
    
    if verbose:
        print("Final adder operands:")
        print("\top1 =  %s" % op1, end="")
        print("\top2 =  %s" % op2, end="")
        print("\n")

    return final_adder


################
##### MAIN #####
################

if __name__ == "__main__":
    main(sys.argv[1:])

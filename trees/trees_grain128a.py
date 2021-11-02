import random
import collections
import networkx as nx

random.seed(100)

def tree_build_ref():
    G = nx.DiGraph()
    nf = ['n_%d' % i for i in range(0, 128)]
    lf = ['l_%d' % i for i in range(0, 128)]

    r = 256

    for i in range(0, r): 
        z1 = 'f_%d' % (i)
        z2 = 'g_%d' % (i)
        
        # f(x)
        G.add_edges_from([(z1, lf[0]), (z1, lf[7]), (z1, lf[38]), (z1, lf[70]), (z1, lf[81]), (z1, lf[96])])
       
        # g(x)
        G.add_edges_from([(z2, lf[0]), (z2, nf[0]), (z2, nf[26]), (z2, nf[56]), (z2, nf[91]), (z2, nf[96]),
                          (z2, nf[3]), (z2, nf[67]), (z2, nf[11]), (z2, nf[13]), (z2, nf[17]), (z2, nf[18]),
                          (z2, nf[27]), (z2, nf[59]), (z2, nf[40]), (z2, nf[48]), (z2, nf[61]), (z2, nf[65]),
                          (z2, nf[68]), (z2, nf[84]),
                          # Grain-128a 
                          (z2, nf[88]),(z2, nf[92]),(z2, nf[93]),(z2, nf[95]),(z2, nf[22]),(z2, nf[24]),(z2, nf[25]),
                          (z2, nf[70]),(z2, nf[78]),(z2, nf[82])])
           
        lf = lf[1:] + ['f_'+str(i)]
        nf = nf[1:] + ['g_'+str(i)]

    return G

def tree_build_alt(f, g):
    G = nx.DiGraph()
    nf = ['n_%d' % i for i in range(0, 128)]
    lf = ['l_%d' % i for i in range(0, 128)]

    r = 256

    for i in range(0, r): 
        z1 = 'f_%d' % (i)
        z2 = 'g_%d' % (i)
        
        # f(x)
        G.add_edges_from([(z1, lf[0]), (z1, lf[f[0]]), (z1, lf[f[1]]), (z1, lf[f[2]]), (z1, lf[f[3]]), (z1, lf[f[4]])])
       
        # g(x)
        G.add_edges_from([(z2, lf[0]), (z2, nf[0]), (z2, nf[g[0]]), (z2, nf[g[1]]), (z2, nf[g[2]]), (z2, nf[g[3]]),
                          (z2, nf[g[4]]), (z2, nf[g[5]]), (z2, nf[g[6]]), (z2, nf[g[7]]), (z2, nf[g[8]]), (z2, nf[g[9]]),
                          (z2, nf[g[10]]), (z2, nf[g[11]]), (z2, nf[g[12]]), (z2, nf[g[13]]), (z2, nf[g[14]]), (z2, nf[g[15]]),
                          (z2, nf[g[16]]), (z2, nf[g[17]]),
                          # Grain-128a
                          (z2, nf[g[18]]), (z2, nf[g[19]]),(z2, nf[g[20]]), (z2, nf[g[21]]),(z2, nf[g[22]]), (z2, nf[g[23]]),
                          (z2, nf[g[24]]), (z2, nf[g[25]]), (z2, nf[g[26]]), (z2, nf[g[27]])])
           
        lf = lf[1:] + ['f_'+str(i)]
        nf = nf[1:] + ['g_'+str(i)]

    return G


def tree_ext(G, node):
    """Extract unrolled strand tree from full Triad graph."""

    def build(parent, parent_id):
        succs = list(G.successors(parent))

        for i in range(len(succs)):
            id = random.randint(1, 10000000)
        
            eq.add_node(id); labels[id] = succs[i]
            eq.add_edge(parent_id, id)
        
            build(succs[i], id)
        return
    
    eq = nx.DiGraph()
    labels = {0: node}
    build(node, 0)
    return eq, labels

def tree_perf(eq, labels):
    """Check whether unrolled strand tree is perfect."""

    s = []
    for n in eq.nodes():
        if eq.out_degree(n) == 0:
            s.append(len(nx.shortest_path(eq, 0, n)))
   
    return len(set(s)) == 1

def tree_count(G, n=256):
    """Count number of perfect unrolled strand trees."""

    p1, p2 = 0, 0
    for i in range(0, n, 1):
        eq, labels = tree_ext(G, 'f_%d' % i)
        p1 += tree_perf(eq, labels)
        
        eq, labels = tree_ext(G, 'g_%d' % i)
        p2 += tree_perf(eq, labels)

    print('====', p1, p2)
    return p1 + p2

def opt(f, g):
    # f
    lf1 = 0
    lg1 = f

    lt1 = lg1 - lf1

    lf2 = 128
    lg2 = 128 + max(lt1 - (128-f), 0)

    lt2 = lg2 - lf2

    # g
    nf1 = 0
    ng1 = g

    nt1 = ng1 - nf1

    nf2 = 128
    #ng2 = 128 + min(max(nt1 - (128-g), 0), max(lt1 - (128 - g), 0))
    ng2 = 128 + max(nt1 - (128-g), 0)
    
    nt2 = ng2 - nf2

    # print(lt1, lt2, nt1, nt2)
    return lt1 + lt2 + nt1 + nt2

random.seed(1)

def vary():
    m = [0]*7
    # for _ in range(100):
    while True:
        f = []
        while len(set(f)) != 5:
            f = sorted([random.randint(1, 40) for _ in range(5)])
        
        g = []
        while len(set(g)) != 28:
            g = sorted([random.randint(1, 40) for _ in range(28)])

        # G = tree_build_alt(f, g)
        
        # t = tree_count(G)
        o = opt(128-f[4], 128-g[27])
        if m[o//50] < 60 and o > 300:
            for i in f: print('%d,' % (128-i), end='')
            for i in g: print('%d,' % (128-i), end='')
            print('%d' % o)
            m[o//50] += 1

        if sum(m) == 20:
            break

# G = tree_build_ref()
# print(tree_count(G))
vary()

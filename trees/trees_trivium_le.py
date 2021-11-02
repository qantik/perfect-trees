import random
import collections
import networkx as nx

def tree_build_ref():
    """Build Trivium equation tree.
    x65 + x92 + (x90 * x91) + x169 
    x161 + x176 + (x174 * x175) + x263 
    x242 + x287 + (x285 * x286) + x68 
    """

    G = nx.DiGraph()
    x = ['x_%d' % i for i in range(0, 288)]

    r = 288
    j = 0

    for i in range(0, r): 
        z1 = 'Z_%d' % (j+1)
        z2 = 'Z_%d' % (j+2)
        z3 = 'Z_%d' % (j+0)
         
        # G.add_edges_from([(z1, x[65]), (z1, x[92]), (z1, x[90]), (z1, x[91]), (z1, x[170])])
        # G.add_edges_from([(z2, x[161]), (z2, x[176]), (z2, x[174]), (z2, x[175]), (z2, x[263])])
        # G.add_edges_from([(z3, x[242]), (z3, x[287]), (z3, x[285]), (z3, x[286]), (z3, x[68])])
        G.add_edges_from([(z1, x[65]), (z1, x[66]), (z1, x[67]), (z1, x[91]), (z1, x[170])])
        G.add_edges_from([(z2, x[161]), (z2, x[162]), (z2, x[163]), (z2, x[175]), (z2, x[263])])
        G.add_edges_from([(z3, x[242]), (z3, x[243]), (z3, x[244]), (z3, x[286]), (z3, x[68])])
           
        x = ['Z_'+str(j)] + x[0:92] + ['Z_'+str(j+1)] + x[93:176] + ['Z_'+str(j+2)] + x[177:287]

        j += 3
    
    return G

def tree_build_alt(a1=66, b1=69, c1=66, fa=78, fb=87, fc=69, a2=93, b2=84, c2=111):
    """Build Trivium equation tree.
    x1_65 + x1_92 + (x1_90 * x1_91) + x2_77
    x2_68 + x2_83 + (x2_81 * x2_82) + x3_86 
    x3_65 + x3_110 + (x3_108 * x3_109) + x1_68 
    """
   
    G = nx.DiGraph()
    x1 = ['x_%d' % i for i in range(0, a2)]
    x2 = ['x_%d' % i for i in range(a2, a2+b2)]
    x3 = ['x_%d' % i for i in range(a2+b2, a2+b2+c2)]
    
    r = 288
    j = 0
    
    for i in range(0, r): 
        z1 = 'Z_%d' % (j+1)
        z2 = 'Z_%d' % (j+2)
        z3 = 'Z_%d' % (j+0)
        
        # G.add_edges_from([(z1, x1[a1-1]), (z1, x1[a2-1]), (z1, x1[a2-3]), (z1, x1[a2-2]), (z1, x2[fa-1])])
        # G.add_edges_from([(z2, x2[b1-1]), (z2, x2[b2-1]), (z2, x2[b2-3]), (z2, x2[b2-2]), (z2, x3[fb-1])])
        # G.add_edges_from([(z3, x3[c1-1]), (z3, x3[c2-1]), (z3, x3[c2-3]), (z3, x3[c2-2]), (z3, x1[fc-1])])
        G.add_edges_from([(z1, x1[a1-1]), (z1, x1[a1+2]), (z1, x1[a1+3]), (z1, x1[a2-2]), (z1, x2[fa-1])])
        G.add_edges_from([(z2, x2[b1-1]), (z2, x2[b1+10]), (z2, x2[b1+20]), (z2, x2[b2-2]), (z2, x3[fb-1])])
        G.add_edges_from([(z3, x3[c1-1]), (z3, x3[c1+3]), (z3, x3[c1+7]), (z3, x3[c2-2]), (z3, x1[fc-1])])

        x1 = ['Z_'+str(j)] + x1[0:a2-1]
        x2 = ['Z_'+str(j+1)] + x2[0:b2-1]
        x3 = ['Z_'+str(j+2)] + x3[0:c2-1]
        
        j += 3

    return G

def tree_ext(G, node):
    """Extract unrolled strand tree from full Trivium graph."""

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

imper = [0]*10

def tree_perf(eq, labels):
    """Check whether unrolled strand tree is perfect."""

    s = []
    for n in eq.nodes():
        if eq.out_degree(n) == 0:
            s.append(len(nx.shortest_path(eq, 0, n)))
    
    if len(set(s)) > 1:
        l = sorted(list(set(s)))
        imper[l[-1] - l[0]] += 1

    return len(set(s)) == 1

def tree_count(G, n=864):
    """Count number of perfect unrolled strand trees."""

    p1, p2, p3 = 0, 0, 0
    for i in range(0, n, 1):
        eq, labels = tree_ext(G, 'Z_%d' % i)
        if i % 3 == 0:
            p1 += tree_perf(eq, labels)
        elif i % 3 == 1:
            p2 += tree_perf(eq, labels)
        else:
            p3 += tree_perf(eq, labels)

    return p1 + p2 + p3

def opt(a1=66, b1=69, c1=66, fa=78, fb=87, fc=69, a2=93, b2=84, c2=111):
    f1a1  = 0; f1a2 = min(a1, fa)
    f1b1  = 0; f1b2 = min(b1, fb)
    f1c1  = 0; f1c2 = min(c1, fc)
    f1 = (f1a2 - f1a1) + (f1b2 - f1b1) + (f1c2 - f1c1)
    
    f2a1 = max(f1c1 + a2, f1a1 + fa)
    f2a2 = min(f1c1 + a2 + max((f1c2 - f1c1) - (a2 - a1), 0), f1a2 + fa)
    f2a = max(f2a2 - f2a1, 0)
    
    f2b1 = max(f1a1 + b2, f1b1 + fb)
    f2b2 = min(f1a1 + b2 + max((f1a2 - f1a1) - (b2 - b1), 0), f1b2 + fb)
    f2b = max(f2b2 - f2b1, 0)
    
    f2c1 = max(f1b1 + c2, f1c1 + fc)
    f2c2 = min(f1b1 + c2 + max((f1b2 - f1b1) - (c2 - c1), 0), f1c2 + fc)
    f2c = max(f2c2 - f2c1, 0)
    
    f2 = f2a + f2b + f2c
    
    f3a1 = max(f2c1 + a2, f2a1 + fa)
    f3a2 = min(f2c1 + a2 + max((f2c2 - f2c1) - (a2 - a1), 0), f2a2 + fa)
    f3a = max(f3a2 - f3a1, 0)
    
    f3b1 = max(f2a1 + b2, f2b1 + fb)
    f3b2 = min(f2a1 + b2 + max((f2a2 - f2a1) - (b2 - b1), 0), f2b2 + fb)
    f3b = max(f3b2 - f3b1, 0)
    
    f3c1 = max(f2b1 + c2, f2c1 + fc)
    f3c2 = min(f2b1 + c2 + max((f2b2 - f2b1) - (c2 - c1), 0), f2c2 + fc)
    f3c = max(f3c2 - f3c1, 0)
    
    f3 = f3a + f3b + f3c
    
    return f1 + f2 + f3

G = tree_build_alt(a1=87, b1=66, c1=75, fa=90, fb=87, fc=78, a2=93, b2=99, c2=96)
# G = tree_build_ref()
print(tree_count(G))
print(imper)
# print(opt(a1=87, b1=66, c1=75, fa=90, fb=87, fc=78, a2=93, b2=99, c2=96))

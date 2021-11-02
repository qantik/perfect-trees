import random
import collections
import networkx as nx

random.seed(100)

def tree_build_ref():
    """
    x67 + x79 + (x72 * x78) + x145 + (x164 * x252) 
    x143 + x167 + (x144 * x166) + x251 
    x235 + x255 + (x244 * x254) + x73 
    """

    G = nx.DiGraph()
    x = ['x_%d' % i for i in range(0, 256)]

    r = 256
    j = 0

    for i in range(0, r): 
        z1 = 'Z_%d' % (j+1)
        z2 = 'Z_%d' % (j+2)
        z3 = 'Z_%d' % (j+0)
        G.add_edges_from([(z1, x[67]), (z1, x[79]), (z1, x[72]), (z1, x[78]), (z1, x[145]), (z1, x[164]), (z1, x[252])])
        G.add_edges_from([(z2, x[143]), (z2, x[167]), (z2, x[144]), (z2, x[166]), (z2, x[251])])
        G.add_edges_from([(z3, x[235]), (z3, x[255]), (z3, x[244]), (z3, x[254]), (z3, x[73])])
           
        x = ['Z_'+str(j)] + x[0:79] + ['Z_'+str(j+1)] + x[80:167] + ['Z_'+str(j+2)] + x[168:255]

        j += 3
    
    return G

def tree_build112(a1=68, b1=64, c1=68, fa=66, fb=84, fc=74, a2=80, b2=88, c2=88, ffa=85, fffa=85):
    """
    x1_67 + x1_79 + (x1_72 * x1_79) + x2_65 + (x2_84 * x3_84)
    x2_63 + x2_87 + (x2_64 * x2_86) + x3_83 
    x3_67 + x3_87 + (x3_76 * x3_86) + x1_73 
    """
   
    G = nx.DiGraph()
    x1 = ['x_%d' % i for i in range(0, a2)]
    x2 = ['x_%d' % i for i in range(a2, a2+b2)]
    x3 = ['x_%d' % i for i in range(a2+b2, a2+b2+c2)]
    
    r = 256
    j = 0
    
    for i in range(0, r): 
        z1 = 'Z_%d' % (j+1)
        z2 = 'Z_%d' % (j+2)
        z3 = 'Z_%d' % (j+0)
        
        G.add_edges_from([(z1, x1[a1-1]), (z1, x1[a2-1]), (z1, x1[a2-3]), (z1, x1[a2-2]), (z1, x2[fa-1]), (z1, x2[ffa-1]), (z1, x3[fffa-1])])
        G.add_edges_from([(z2, x2[b1-1]), (z2, x2[b2-1]), (z2, x2[b2-3]), (z2, x2[b2-2]), (z2, x3[fb-1])])
        G.add_edges_from([(z3, x3[c1-1]), (z3, x3[c2-1]), (z3, x3[c2-3]), (z3, x3[c2-2]), (z3, x1[fc-1])])

        x1 = ['Z_'+str(j)] + x1[0:a2-1]
        x2 = ['Z_'+str(j+1)] + x2[0:b2-1]
        x3 = ['Z_'+str(j+2)] + x3[0:c2-1]
        
        j += 3

    return G

def tree_build80(a1=68, b1=64, c1=68, fa=66, fb=84, fc=74, a2=80, b2=88, c2=88):
    """
    x1_67 + x1_79 + (x1_72 * x1_79) + x2_65
    x2_63 + x2_87 + (x2_64 * x2_86) + x3_83 
    x3_67 + x3_87 + (x3_76 * x3_86) + x1_73 
    """
   
    G = nx.DiGraph()
    x1 = ['x_%d' % i for i in range(0, a2)]
    x2 = ['x_%d' % i for i in range(a2, a2+b2)]
    x3 = ['x_%d' % i for i in range(a2+b2, a2+b2+c2)]
    
    r = 256
    j = 0
    
    for i in range(0, r): 
        z1 = 'Z_%d' % (j+1)
        z2 = 'Z_%d' % (j+2)
        z3 = 'Z_%d' % (j+0)
        
        G.add_edges_from([(z1, x1[a1-1]), (z1, x1[a2-1]), (z1, x1[a2-3]), (z1, x1[a2-2]), (z1, x2[fa-1])])
        G.add_edges_from([(z2, x2[b1-1]), (z2, x2[b2-1]), (z2, x2[b2-3]), (z2, x2[b2-2]), (z2, x3[fb-1])])
        G.add_edges_from([(z3, x3[c1-1]), (z3, x3[c2-1]), (z3, x3[c2-3]), (z3, x3[c2-2]), (z3, x1[fc-1])])

        x1 = ['Z_'+str(j)] + x1[0:a2-1]
        x2 = ['Z_'+str(j+1)] + x2[0:b2-1]
        x3 = ['Z_'+str(j+2)] + x3[0:c2-1]
        
        j += 3

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

def tree_count(G, n=768):
    """Count number of perfect unrolled strand trees."""

    for i in range(0, n, 1):
        eq, labels = tree_ext(G, 'Z_%d' % i)
        if i % 3 == 0:
            p1 += tree_perf(eq, labels)
        elif i % 3 == 1:
            p2 += tree_perf(eq, labels)
        else:
            p3 += tree_perf(eq, labels)

    return p1 + p2 + p3

def opt112(a1=68, b1=64, c1=68, fa=66, fb=84, fc=74, a2=80, b2=88, c2=88, ffa=85, fffa=85):
    f1a1  = 0; f1a2 = min(a1, min(fa, ffa, fffa))
    f1b1  = 0; f1b2 = min(b1, fb)
    f1c1  = 0; f1c2 = min(c1, fc)
    f1 = (f1a2 - f1a1) + (f1b2 - f1b1) + (f1c2 - f1c1)
    
    f2a1 = max(f1c1 + a2, f1a1 + fa, f1a1+ffa, f1b1+fffa)
    f2a2 = min(f1c1 + a2 + max((f1c2 - f1c1) - (a2 - a1), 0), f1a2 + fa, f1a2+ffa, f1b2+fffa)
    f2a = max(f2a2 - f2a1, 0)
    
    f2b1 = max(f1a1 + b2, f1b1 + fb)
    f2b2 = min(f1a1 + b2 + max((f1a2 - f1a1) - (b2 - b1), 0), f1b2 + fb)
    f2b = max(f2b2 - f2b1, 0)
    
    f2c1 = max(f1b1 + c2, f1c1 + fc)
    f2c2 = min(f1b1 + c2 + max((f1b2 - f1b1) - (c2 - c1), 0), f1c2 + fc)
    f2c = max(f2c2 - f2c1, 0)
    
    f2 = f2a + f2b + f2c
    
    f3a1 = max(f2c1 + a2, f2a1 + fa, f2a1+ffa, f2b1+fffa)
    f3a2 = min(f2c1 + a2 + max((f2c2 - f2c1) - (a2 - a1), 0), f2a2 + fa, f2a2+ffa, f2b2+fffa)
    f3a = max(f3a2 - f3a1, 0)
    
    f3b1 = max(f2a1 + b2, f2b1 + fb)
    f3b2 = min(f2a1 + b2 + max((f2a2 - f2a1) - (b2 - b1), 0), f2b2 + fb)
    f3b = max(f3b2 - f3b1, 0)
    
    f3c1 = max(f2b1 + c2, f2c1 + fc)
    f3c2 = min(f2b1 + c2 + max((f2b2 - f2b1) - (c2 - c1), 0), f2c2 + fc)
    f3c = max(f3c2 - f3c1, 0)
    
    f3 = f3a + f3b + f3c
    
    return f1 + f2 + f3

def opt80(a1=68, b1=64, c1=68, fa=66, fb=84, fc=74, a2=80, b2=88, c2=88):
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

def vary_all(trunc=False):
    t = [0]*8
    for x in range(0, 40):
        for y in range(-8, 32):
            for z in range(-8, 32):
                if (x + y + z) == 0 and x % 2 == 0 and y % 2 == 0 and z % 2 == 0:
                    a2 = 80+x
                    b2 = 88+y
                    c2 = 88+z

                    for i in range(100000):
                        a1 = random.randint(60, a2-5)
                        b1 = random.randint(60, b2-5)
                        c1 = random.randint(60, c2-5)
                        
                        fa = random.randint(b1+1, b2-3)
                        fb = random.randint(c1+1, c2-3)
                        fc = random.randint(a1+1, a2-3)

                        ffa = random.randint(b1+1, b2-4)
                        fffa = random.randint(c1+1, c2-4)

                        if trunc:
                            o = opt80(a1=a1, b1=b1, c1=c1, a2=a2, b2=b2, c2=c2, fa=fa, fb=fb, fc=fc)
                            if o >= 670:
                                print('%d,%d,%d,%d,%d,%d,%d,%d,%d,%d'
                                    % (a1, a2+b1, a2+b2+c1,
                                       fc, a2+fa, a2+b2+fb,
                                       a2, b2+a2, a2+b2+c2, o))
                        else:
                            o = opt112(a1=a1, b1=b1, c1=c1, a2=a2, b2=b2, c2=c2, fa=fa, fb=fb, fc=fc, ffa=ffa, fffa=fffa)
                            if t[o//100] < 70 and a1 % 2 == 0 and b1 % 2 == 0 and c1 % 2 == 0 and fa % 2 == 0 and fb % 2 == 0 and fc % 2 == 0:
                                print('%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d'
                                    % (a1, a2+b1, a2+b2+c1,
                                       fc, a2+fa, a2+b2+fb,
                                       a2, b2, c2, ffa+a2, fffa+a2+b2, o))
                                t[o//100] += 1

                        # g = tree_build(a1=a1, b1=b1, c1=c1, a2=a2, b2=b2, c2=c2, fa=fa, fb=fb, fc=fc, ffa=ffa, fffa=fffa)
                        # assert tree_count(g) == o

vary_all()

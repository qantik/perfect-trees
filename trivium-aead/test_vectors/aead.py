import sys
sys.path.insert(0, '../../')
from common import *

def setup(k, iv):
    s = [0] * 288
    
    s[0:80] = k
    s[93:173] = iv
    s[285], s[286], s[287] = 1, 1, 1
    return s

# def init(s):
#     for i in range(4*288):
#         # print(i, b2h(s, 288))
        
#         t1 = s[86]  ^ (s[87]  & s[88])  ^ s[92]  ^ s[182]
#         t2 = s[158] ^ (s[159] & s[160]) ^ s[191] ^ s[278]
#         t3 = s[266] ^ (s[267] & s[268]) ^ s[287] ^ s[77]

#         s = [t3] + s[0:92] + [t1] + s[93:191] + [t2] + s[192:287]
        
#     return s

def upd(s, d):
    z = [0]*288
    for i in range(288):
        t1 = s[86]  ^ s[92]
        t2 = s[158] ^ s[191]
        t3 = s[266] ^ s[287]

        z[i] = t1 ^ t2 ^ t3

        t1 = t1 ^ (s[87]  & s[88])  ^ s[182]
        t2 = t2 ^ (s[159] & s[160]) ^ s[278] ^ d[i]
        t3 = t3 ^ (s[267] & s[268]) ^ s[77] ^ d[i]

        s[98] ^= d[i] # inject data into register
        
        s = [t3] + s[0:92] + [t1] + s[93:191] + [t2] + s[192:287]

    # print(b2h(s, 288))
    return s, z

def mac(k, iv, data):
    s = setup(k, iv)
    for d in data:
        s, t = upd(s, d)
   
    return s, t

def sc(k, iv, data):
    s = setup(k, iv)
    for i in range(4):
        s, _ = upd(s, data[i])

    c = []
    for d in data[4:]:
        s, z = upd(s, [0]*288)
        for i in range(288):
            z[i] ^= d[i]

        c.append(z)

    return s, c

def run(k, iv, mac_data, sc_data):
    _, t = mac(k, iv, mac_data)
    _, c = sc(k, iv, sc_data)
    return t, c


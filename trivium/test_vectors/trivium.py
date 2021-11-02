import sys
sys.path.insert(0, '../../')
from common import *

def setup(k, iv):
    s = [0] * 288
    
    s[0:80] = k
    s[93:173] = iv
    s[285], s[286], s[287] = 1, 1, 1
    return s

def init(s):
    for i in range(4*288):
        # print(i, b2h(s, 288))
        
        t1 = s[65]  ^ (s[90]  & s[91])  ^ s[92]  ^ s[170]
        t2 = s[161] ^ (s[174] & s[175]) ^ s[176] ^ s[263]
        t3 = s[242] ^ (s[285] & s[286]) ^ s[287] ^ s[68]

        s = [t3] + s[0:92] + [t1] + s[93:176] + [t2] + s[177:287]
        
    return s

def stream(s, n):
    z = [0] * n
    for i in range(n):
        t1 = s[65]  ^ s[92]
        t2 = s[161] ^ s[176]
        t3 = s[242] ^ s[287]

        z[i] = t1 ^ t2 ^ t3

        t1 = t1 ^ (s[90]  & s[91])  ^ s[170]
        t2 = t2 ^ (s[174] & s[175]) ^ s[263]
        t3 = t3 ^ (s[285] & s[286]) ^ s[68]
        
        s = [t3] + s[0:92] + [t1] + s[93:176] + [t2] + s[177:287]

    return z

def run(k, iv, n=288):
    _k  = i2b(k, 80)
    _iv = i2b(iv, 80)

    s  = setup(_k, _iv)
    s  = init(s)
    return stream(s, n)

# ks = trivium(0, 0)
# print(b2h(ks, 288))

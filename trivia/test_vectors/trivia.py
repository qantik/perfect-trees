import sys
sys.path.insert(0, '../../')
from common import *

def setup(k, iv):
    s = [1] * 384
    
    s[0:128] = k
    s[237:265] = iv
    return s

def init(s):
    for i in range(3*384):
        # print(i, b2h(s, 288))
        
        t1 = s[65]  ^ (s[129]  & s[130])  ^ s[131]  ^ s[227]
        t2 = s[200] ^ (s[234] & s[235]) ^ s[236] ^ s[356]
        t3 = s[302] ^ (s[381] & s[382]) ^ s[383] ^ s[74]

        s = [t3] + s[0:131] + [t1] + s[132:236] + [t2] + s[237:383]
        
    return s

def stream(s, n):
    z = [0] * n
    for i in range(n):
        t1 = s[65]  ^ s[131]
        t2 = s[200] ^ s[236]
        t3 = s[302] ^ s[383]

        z[i] = t1 ^ t2 ^ t3 ^ (s[101] & s[197])

        t1 = t1 ^ (s[129]  & s[130])  ^ s[227]
        t2 = t2 ^ (s[234] & s[235]) ^ s[356]
        t3 = t3 ^ (s[381] & s[382]) ^ s[74]
        
        s = [t3] + s[0:131] + [t1] + s[132:236] + [t2] + s[237:383]

    return z

def run(k, iv, n=384):
    _k  = i2b(k, 128)
    _iv = i2b(iv, 128)

    s  = setup(_k, _iv)
    s  = init(s)
    return stream(s, n)


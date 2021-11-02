import sys
sys.path.insert(0, '../../')
from common import *

def setup(k, iv):
    s = [0] * 256

    s[0:8] = iv[0:8]
    s[8:16] = k[32:40]
    s[16:24] = [1]*8
    s[24:32] = k[24:32]
    s[32:40] = [1]*8
    s[40:48] = k[16:24]
    s[48:56] = [1]*8
    s[56:64] = k[8:16]
    s[64:72] = [1, 1, 1, 1, 1, 1, 1, 0]
    s[72:80] = k[0:8]
    s[80:168] = iv[88:96] + iv[80:88] + iv[72:80] + iv[64:72] + iv[56:64] + iv[48:56] + iv[40:48] + iv[32:40] + iv[24:32] + iv[16:24] + iv[8:16]
    s[168:256] = k[120:128] + k[112:120] + k[104:112] + k[96:104] + k[88:96] + k[80:88] + k[72:80] + k[64:72] + k[56:64] + k[48:56] + k[40:48]

    return s

def upd(s, d):
    z = [0]*256
    
    for i in range(256):
        # t1 = s[67]  ^ s[79] ^ (s[164] & s[252])
        # t2 = s[143] ^ s[167]
        # t3 = s[235] ^ s[255]

        # z[i] = t1 ^ t2 ^ t3

        # t1 = t1 ^ (s[72]  & s[78])  ^ s[145] ^ d[i]
        # t2 = t2 ^ (s[144] & s[166]) ^ s[251] ^ d[i]
        # t3 = t3 ^ (s[244] & s[254]) ^ s[73] ^ d[i]
        
        # s = [t3] + s[0:79] + [t1] + s[80:167] + [t2] + s[168:255]
        
        t1 = s[67]  ^ s[79] ^ (s[164] & s[252])
        t2 = s[143] ^ s[167]
        t3 = s[245] ^ s[255]

        z[i] = t1 ^ t2 ^ t3

        t1 = t1 ^ (s[72]  & s[78])  ^ s[163] ^ d[i]
        t2 = t2 ^ (s[146] & s[166]) ^ s[241] ^ d[i]
        t3 = t3 ^ (s[250] & s[254]) ^ s[75] ^ d[i]
        
        s = [t3] + s[0:79] + [t1] + s[80:167] + [t2] + s[168:255]

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
        s, z = upd(s, [0]*256)
        for i in range(256):
            z[i] ^= d[i]

        c.append(z)

    return s, c

def run(k, iv, mac_data, sc_data):
    _, t = mac(k, iv, mac_data)
    _, c = sc(k, iv, sc_data)
    return t, c


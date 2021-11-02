import sys
sys.path.insert(0, '../../')
from common import *

import random
import aead

random.seed(2)

_LEN = 288

_Z  = [0]*288
_P  = i2b(0x000000000000000000000000000000000000000000000000000000000000000000000000, 288)
_PB = i2b(0x800000000000000000000000000000000000000000000000000000000000000000000000, 288)

def enc_len(x):
    l = 0x0
    l |= (x & 0xFF) << 280
    l |= ((x >> 8) & 0xFF) << 272
    l |= ((x >> 16) & 0xFF) << 264
    l |= ((x >> 24) & 0xFF) << 256
    l |= ((x >> 32) & 0xFF) << 248
    l |= ((x >> 40) & 0xFF) << 240
    l |= ((x >> 48) & 0xFF) << 232

    return i2b(l, 288)

def gen(n=1):
    for i in range(n):
        key = i2b(random.randint(0, 2**80-1), 80)
        iv  = i2b(random.randint(0, 2**80-1), 80)

        ad_len = random.randint(1, 20)
        msg_len = random.randint(1, 20)

        ad = [i2b(random.randint(0, 2**288-1), 288) for _ in range(ad_len)]
        msg = [i2b(random.randint(0, 2**288-1), 288) for _ in range(msg_len)]

        mac_data = [_PB, _Z, _Z, _Z] + ad + [enc_len(ad_len)] + msg + [enc_len(msg_len), _PB, _Z, _Z, _Z, _Z]
        sc_data  = [_P, _Z, _Z, _Z] + msg

        t, c = aead.run(key, iv, mac_data, sc_data)

        print(i, len(mac_data), len(sc_data))
        print(b2h(key, 80))
        print(b2h(iv, 80))
        for m in mac_data: print(b2h(m, 288))
        print(b2h(t, 288))
        for s in sc_data: print(b2h(s, 288))
        # print(b2h(c[0], 288))

gen(100)


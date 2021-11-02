import sys
sys.path.insert(0, '../../')
from common import *

import random
import grain_128aead

random.seed(1)

_ZK = i2b(0, 128)
_ZI = i2b(0, 96)

_LEN = 256

def gen(n=1):
    for i in range(n):
        key = i2b(random.randint(0, 2**128-1), 128)#_ZK#i2b(0x008040C020A060E0109050D030B070F0, 128)
        iv  = i2b(random.randint(0, 2**96-1), 96)#_ZI#i2b(0x008040C020A060E0109050D0, 96)

        ad_start = i2b(0, 8)
        pad    = [1, 0, 0, 0, 0, 0, 0, 0]

        ad_len = random.randint(0, 10)
        msg_len = random.randint(0, 10) 

        #ad = ad_len + i2b(0x008040C020A060E0, 64)
        #msg = i2b(0x008040C020A060E0, 64) + pad
        ad_init = ad_start + i2b(random.randint(0, 2**120-1), 120)
        msg_last = i2b(random.randint(0, 2**120-1), 120) + pad

        ads = ad_init
        msgs = []
        for _ in range(ad_len): ads.extend(i2b(random.randint(0, 2**128-1), 128))
        for _ in range(msg_len): msgs.extend(i2b(random.randint(0, 2**128-1), 128))
        msgs.extend(msg_last)

        c, t = grain_128aead.run(key, iv, ads, msgs)

        print(i, 2*ad_len + 2, 2*msg_len + 2)
        print(b2h(key, 128))
        print(b2h(iv, 96))
        for j in range(2*ad_len+2):
            print(b2h(ads[64*j:64*(j+1)], 64))
        for j in range(2*msg_len+2):
            print(b2h(msgs[64*j:64*(j+1)], 64))

        print(b2h(t, 64))

gen(100)

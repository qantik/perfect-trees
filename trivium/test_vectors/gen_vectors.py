import sys
sys.path.insert(0, '../../')
from common import *

import random
import trivium

random.seed(0)

_LEN = 288

def gen(n=1):
    for i in range(n):
        key = random.randint(0, 2**80-1)
        iv  = random.randint(0, 2**80-1)

        ks = trivium.run(key, iv, _LEN)

        print(i)
        print(i2h(key, 80))
        print(i2h(iv, 80))
        print(b2h(ks, _LEN))

gen(100)

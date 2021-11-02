import sys
sys.path.insert(0, '../../')
from common import *

import random
import triad

random.seed(0)

_LEN = 256

def gen(n=1):
    for i in range(n):
        key = random.randint(0, 2**128-1)
        iv  = random.randint(0, 2**96-1)

        ks = triad.run(key, iv, _LEN)

        print(i)
        print(i2h(key, 128))
        print(i2h(iv, 96))
        print(b2h(ks, _LEN))

gen(100)

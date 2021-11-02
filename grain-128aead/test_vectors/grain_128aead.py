import sys
sys.path.insert(0, '../../')
from common import *

def rev(x, n):
    for i in range(n//8):
        print(b2h(x[i*8:(i+1)*8][::-1], 8), end='')
    print()

def setup(k, iv):
    n = [1]*128
    l = [1]*128

    a = [0]*64
    r = [0]*64
    
    n[0:128] = k
    l[0:96] = iv
    l[127] = 0
    return n, l, a, r

def init(n, l, a, r, k):
    for i in range(3*128):
        # if i % 128 == 0:
        #     print(i, b2h(n, 128))
        #     print(i, b2h(l, 128))
       
        tl = l[0] ^ l[7] ^ l[38] ^ l[70] ^ l[81] ^ l[96]
        tn = l[0] ^ n[0] ^ n[26] ^ n[56] ^ n[91] ^ n[96] \
            ^ (n[3] & n[67]) ^ (n[11] & n[13]) ^ (n[17] & n[18]) \
            ^ (n[27] & n[59]) ^ (n[40] & n[48]) ^ (n[61] & n[65]) \
            ^ (n[68] & n[84]) ^ (n[22] & n[24] & n[25]) ^ (n[70] & n[78] & n[82]) \
            ^ (n[88] & n[92] & n[93] & n[95])

        z = (n[12] & l[8]) ^ (l[13] & l[20]) ^ (n[95] & l[42]) ^ (l[60] & l[79]) ^ (n[12] & n[95] & l[94]) \
            ^ l[93] ^ n[2] ^ n[15] ^ n[36] ^ n[45] ^ n[64] ^ n[73] ^ n[89]

        if i >= 256 and i < 320:
            a[i-256] = z
        elif i >= 320:
            r[i-320] = z
       
        if i < 256:
            n = n[1:128] + [tn ^ z]
            l = l[1:128] + [tl ^ z]
        else:
            n = n[1:128] + [tn]
            l = l[1:128] + [tl ^ k[i-256]]

    return n, l, a, r

def stream(n, l, a, r, ad, msg):
    c = [0]*len(msg)
    for i in range(len(ad)*2):
        # if i % 128 == 0:
        #     print(i, b2h(n, 128))
        #     print(i, b2h(l, 128))
        #     print(i, b2h(a, 64))
        #     print(i, b2h(r, 64))
        tl = l[0] ^ l[7] ^ l[38] ^ l[70] ^ l[81] ^ l[96]
        tn = l[0] ^ n[0] ^ n[26] ^ n[56] ^ n[91] ^ n[96] \
            ^ (n[3] & n[67]) ^ (n[11] & n[13]) ^ (n[17] & n[18]) \
            ^ (n[27] & n[59]) ^ (n[40] & n[48]) ^ (n[61] & n[65]) \
            ^ (n[68] & n[84]) ^ (n[22] & n[24] & n[25]) ^ (n[70] & n[78] & n[82]) \
            ^ (n[88] & n[92] & n[93] & n[95])

        z = (n[12] & l[8]) ^ (l[13] & l[20]) ^ (n[95] & l[42]) ^ (l[60] & l[79]) ^ (n[12] & n[95] & l[94]) \
            ^ l[93] ^ n[2] ^ n[15] ^ n[36] ^ n[45] ^ n[64] ^ n[73] ^ n[89]

        if i % 2 == 0:
            pass
        else:
            for j in range(64): a[j] = a[j] ^ (ad[i//2] & r[j])
            r = r[1:] + [z]
        
        n = n[1:128] + [tn]
        l = l[1:128] + [tl]
            
    # print(i, b2h(n, 128))
    # print(i, b2h(l, 128))
    # print(i, b2h(a, 64))
    # print(i, b2h(r, 64))
        
    for i in range(len(msg)*2):
        tl = l[0] ^ l[7] ^ l[38] ^ l[70] ^ l[81] ^ l[96]
        tn = l[0] ^ n[0] ^ n[26] ^ n[56] ^ n[91] ^ n[96] \
            ^ (n[3] & n[67]) ^ (n[11] & n[13]) ^ (n[17] & n[18]) \
            ^ (n[27] & n[59]) ^ (n[40] & n[48]) ^ (n[61] & n[65]) \
            ^ (n[68] & n[84]) ^ (n[22] & n[24] & n[25]) ^ (n[70] & n[78] & n[82]) \
            ^ (n[88] & n[92] & n[93] & n[95])

        z = (n[12] & l[8]) ^ (l[13] & l[20]) ^ (n[95] & l[42]) ^ (l[60] & l[79]) ^ (n[12] & n[95] & l[94]) \
            ^ l[93] ^ n[2] ^ n[15] ^ n[36] ^ n[45] ^ n[64] ^ n[73] ^ n[89]

        #if i % 2 == 0 and i < len(msg)*2 - 16:
        if i % 2 == 0:
            c[i//2] = msg[i//2] ^ z
        else:
            for j in range(64): a[j] = a[j] ^ (msg[i//2] & r[j])
            r = r[1:] + [z]

        n = n[1:128] + [tn]
        l = l[1:128] + [tl]

    return c[:128], a

def run(k, iv, ad, msg):
    n, l, a, r = setup(k, iv)
    n, l, a, r = init(n, l, a, r, k)
    # print(b2h(n, 128))
    # print(b2h(l, 128))
    # print(b2h(a, 64))
    # print(b2h(r, 64))
    c, t  = stream(n, l, a, r, ad, msg)
    # print(b2h(c, 128))
    # print(b2h(t, 64))
    return c, t


def b2h(x, n):
    return '{:0{}X}'.format(b2i(x), n//4)

def i2h(x, n):
    return '{:0{}X}'.format(x, n//4)

def b2i(x):
    return int(''.join(str(b) for b in x), 2)

def i2b(x, n):
    bits = [0]*n
    for i in range(n):
        b = (x >> i) & 0x1
        bits[n-1-i] = b
    return bits

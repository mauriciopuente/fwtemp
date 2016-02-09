from itertools import izip

a = [1,2,3,4,5,6,7,8,9,10,11,12]

def chunker(iterable, chunksize):
    return zip(*[iter(iterable)]*chunksize)

print chunker(a,4)

for j in chunker(a,4):
    print j








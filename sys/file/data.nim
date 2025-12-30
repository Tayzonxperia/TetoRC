import posix




## START ##
###########

type VfsInfo* = object
    path*: string
    fsid*: uint64
    blockSize*, fragmentSize*: c_ulong
    totalBlocks*, freeBlocks*, availBlocks*: c_ulong
    totalInodes*, freeInodes*, availInodes*: c_ulong
    readOnly*: bool
    status*: int
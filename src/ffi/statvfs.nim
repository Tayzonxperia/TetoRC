import posix

## START ##
###########



proc statvfs*(
    path: cstring,
    buf: StatVfs):
 cint {.importc: "statvfs", header: "<sys/statvfs.h>", cdecl.}

proc fstatvfs*(
    fd: cint,
    buf: StatVfs):
 cint {.importc: "fstatvfs", header: "<sys/statvfs.h>", cdecl.}
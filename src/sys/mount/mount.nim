import posix




## START ##
###########

proc mount*(source, target, fsType: cstring, flags: uint, data: pointer): 
 cint {.importc: "mount", header: "<sys/mount.h>" cdecl.} 

proc umount2*(target: cstring, flags: uint): 
 cint {.importc: "umount2", header: "<sys/mount.h>" cdecl.}

proc swapon*(path: cstring, flags: cint):
 cint {.importc: "swapon", header: "<sys/swap.h>", cdecl.}

proc swapoff*(path: cstring):
 cint {.importc: "swapoff", header: "<sys/swap.h>", cdecl.}
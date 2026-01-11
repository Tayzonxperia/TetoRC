import syscall

## START ##
###########



#[ Sometimes.. you just need a fucking syscall...
   so here is a template file so the compiler 
   handles this shit for us, yay ]#

func sysWrite*(
    msg: cstring):
    clong =
    return syscall(WRITE, msg, len(msg)) 

func sysRead*(
    fd: cint,
    buf: ptr cint,
    size: csize_t):
    clong =
    return syscall(READ, fd, buf, size)

template sysExit*(
    errno: cint)
    =
    discard syscall(EXIT, errno)

template sysWrEx*(
    msg: cstring,
    errno: cint)
    =
    discard syscall(WRITE, msg, len(msg))
    discard syscall(EXIT, errno)

template sysSync*()
    = discard syscall(SYNC)

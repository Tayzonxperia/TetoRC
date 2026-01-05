import posix, syscall

import "sys/init/sighandler"

{.compile: "ct/teto_section.c".}

## START ##
###########



regSigHandler() 

if getpid() != 1:
    discard kill(getPid(), SIGABRT)


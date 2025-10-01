import posix, os 

import "../include/dposix", "../settings/hardcode", "../settings/runtime", msg


## sighandler
proc sighandler*(sig: cint) {.cdecl, noconv.} =
    case sig
    of posix.SIGCHLD:
        REC_SIGCHLD = true
    of posix.SIGTERM:
        REC_SIGTERM = true
    of posix.SIGUSR1:
        REC_SIGUSR1 = true
    of posix.SIGUSR2:
        REC_SIGUSR2 = true
    else:
        discard

## initsignals
proc initsignals*() =
    signal(posix.SIGCHLD, sighandler)
    signal(posix.SIGTERM, sighandler)
    signal(posix.SIGUSR1, sighandler)
    signal(posix.SIGUSR2, sighandler)

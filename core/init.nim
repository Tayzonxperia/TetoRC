import posix, os 

import "../include/dposix", "../settings/hardcode", "../settings/runtime", msg

proc sigreciver*[T](sig: T, signum: T) {.cdecl, inline.} =
    when T is string:
        sig.cstring
    elif T is cstring:
        sig
    elif T is int:
        signum.cint
    elif T is cint:
        signum
    case signum
    of SIGTERM: REC_SIGTERM = true
    of SIGHUP: REC_SIGHUP = true
    of SIGCHLD: REC_SIGCHLD = true
    of SIGUSR1: REC_SIGUSR1 = true
    of SIGUSR2: REC_SIGUSR2 = true
    else:
        discard

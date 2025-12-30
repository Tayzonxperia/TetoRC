import posix

import "../ct/constants"


## START ##
###########

type Criticallity* = enum
    Fatal, # Panic (Error)
    Required, # Fail, halt system (Error)
    Optional, # Continue degraded (Warn)
    NotRequired # Warn, log, move on (Warn)


# These are for initPanic() #
# reg dumping - Do not mess #
# with this - Not even i #
# know what the hell its for #

type Gregs = array[23, culong]

type MContext = object
    gregs: Gregs

type UContext = object
    flags: culong
    link: pointer
    stack: pointer
    mcontext: MContext

const REG_NAMES = [
    ("R8", 0),
    ("R9", 1),
    ("R10", 2),
    ("R11", 3),
    ("R12", 4),
    ("R13", 5),
    ("R14", 6),
    ("R15", 7),
    ("RDI", 8),
    ("RSI", 9),
    ("RBP", 10),
    ("RBX", 11),
    ("RDX", 12),
    ("RAX", 13),
    ("RCX", 14),
    ("RSP", 15),
    ("RIP", 16)
]

proc initPanic(
    signum: cint,
    info: ptr Siginfo,
    uctx: pointer)  
    {.cdecl, noconv.} =

    let ctx = cast[ptr UContext](uctx)
    let g = ctx.mcontext.gregs
    
    stderr.write(BOLD & "\n<TASK>\n")
    for (reg, idx) in REG_NAMES:
        when not defined debug:
            if idx >= 8:
                stderr.write(reg & ": ", $g[idx] & "\n")
        else:
            stderr.write(reg & ": ", $g[idx] & "\n")
    stderr.write("</TASK>\n" & RESET)

var sa: Sigaction
zeroMem(sa.addr, sizeof(sa))

sa.sa_sigaction = initPanic
sa.sa_flags = SA_SIGINFO
discard sigemptyset(sa.sa_mask)

signal(SIGSEGV, sa.sa_handler)
signal(SIGABRT, sa.sa_handler)
signal(SIGILL, sa.sa_handler)
signal(SIGFPE, sa.sa_handler)

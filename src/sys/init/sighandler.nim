import posix, syscall

import "../power/poweroff"
import "../../util/safe_output", "../../util/escape_codes"

when not defined(debug):
    {.push optimization:speed, checks:off, warnings:off.}
    # Use these regardless of what is defined, apart from debug

## START ##
###########



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


when defined(daemon):
    proc initChildHandler(
        signum: cint,
        info: nil,
        uctx: nil) 
        {.cdecl, noconv, inline.} =
        # inline this, its called many times
        var status: cint

        while true:
            let pid = waitpid(-1, status, WNOHANG)
            if pid == 0:
                break
            elif pid == -1:
                if errno == ECHILD:
                    break
                safePrint(Print, "%s(Error)%s TetoRC - waitpid() failed on child: %d", RED, RESET, pid)
                continue

when defined(daemon):
    proc initSigHandler(
        signum: cint,
        info: nil,
        uctx: nil)
        {.cdecl, noconv.} =
        case signum
        of SIGINT:
            handlePoweroff("reboot")
        of SIGTERM:
            handlePoweroff("shutdown")
        else:
            safePrint(Print, "%s(Error)%s TetoRC - Unknown signal encountered: %d", RED, RESET, signum)

proc initPanicHandler(
    signum: cint,
    info: ptr Siginfo,
    uctx: pointer)  
    {.cdecl, noconv.} =

    let ctx = cast[ptr UContext](uctx)
    let g = ctx.mcontext.gregs 

    let trace: cstring = getStackTrace()
    safePrint(Trace, "%sStack trace: %s<TASK>\n", BOLD, trace)

    for (reg, idx) in REG_NAMES:
        when not defined debug:
                if idx >= 8:
                    safePrint(Print, "%s:  %s\n", reg, cstring($g[idx])) 
        else:
            safePrint(Print, "%s:  %s\n", reg, cstring($g[idx])) 

    #[ Making g[idx] a string is a dirty hack, I can't figure out how to
       make %d handle large numbers, so fuck it, we use a (c)string ]#

    safePrint(Print, "</TASK>%s\n", RESET)
    discard sleep(1); sync()
    discard syscall(EXIT, 1) #[ Force exit now to avoid
    half-state returns and corrupt states, auto-reboot 
    will be added later ]#


proc regSigHandler*()
    =
    var signals: SigSet
    var dud_signals: SigSet

    #[ Another dirty hack, again if
       someone can fix this, i would
       love to know ]#

    discard sigfillset(signals)
    when defined(daemon):
        discard sigdelset(signals, SIGCHLD)
        discard sigdelset(signals, SIGINT)        
        discard sigdelset(signals, SIGTERM)
    discard sigdelset(signals, SIGSEGV)
    discard sigdelset(signals, SIGABRT)
    discard sigdelset(signals, SIGILL)
    discard sigdelset(signals, SIGFPE)

    discard sigprocmask(SIG_SETMASK, signals, dud_signals)

    var sa: Sigaction
    zeroMem(sa.addr, sizeof(sa))

    when defined(daemon):
        sa.sa_sigaction = initChildHandler
        discard sigaction(SIGCHLD, sa, nil)

    when defined(daemon):
        sa.sa_sigaction = initSigHandler
        discard sigaction(SIGINT, sa, nil)
        discard sigaction(SIGTERM, sa, nil)
    
    sa.sa_sigaction = initPanicHandler
    discard sigaction(SIGSEGV, sa, nil)
    discard sigaction(SIGABRT, sa, nil)
    discard sigaction(SIGILL, sa, nil)
    discard sigaction(SIGFPE, sa, nil)

when not defined(debug):
    {.pop.}
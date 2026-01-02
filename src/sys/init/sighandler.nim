import posix, syscall

import "../../data/constants", "../power/poweroff"



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
        info: ptr Siginfo,
        uctx: pointer) 
        {.cdecl, noconv.} =
        let errormsg: cstring = RED & "Error: " & RESET & "TetoRC - waitpid() on child failed"
        var status: cint

        while true:
            let pid = waitpid(-1, status, WNOHANG)
            if pid == 0:
                break
            elif pid == -1:
                if errno == ECHILD:
                    break
                discard syscall(WRITE, STDERR_FILENO, errormsg, errormsg.len)
                continue

when defined(daemon):
    proc initSigHandler(
        signum: cint,
        info: ptr Siginfo,
        uctx: pointer)
        {.cdecl, noconv.} =
        case signum
        of SIGINT:
            handlePoweroff("reboot")
        of SIGTERM:
            handlePoweroff("shutdown")
        else:
            let errormsg: cstring = RED & "Error: " & RESET & "TetoRC - Unknown signal encountered: " & $signum
            discard syscall(WRITE, STDERR_FILENO, errormsg, errormsg.len)

proc initPanicHandler(
    signum: cint,
    info: ptr Siginfo,
    uctx: pointer)  
    {.cdecl, noconv.} =

    let ctx = cast[ptr UContext](uctx)
    let g = ctx.mcontext.gregs 

    let panicmsg_start: cstring = BOLD & "\nStack Trace: "
    discard syscall(WRITE, STDOUT_FILENO, panicmsg_start, panicmsg_start.len)

    let trace: cstring = cstring(getStackTrace() & "<TASK>\n")
    discard syscall(WRITE, STDOUT_FILENO, trace, trace.len)

    for (reg, idx) in REG_NAMES:
        when not defined debug:
                if idx >= 8:
                    stderr.write(reg & ": ", $g[idx] & "\n")
        else:
            stderr.write(reg & ": ", $g[idx] & "\n")


    let panicmsg_end: cstring = "</TASK>\n" & RESET
    discard syscall(WRITE, STDOUT_FILENO, panicmsg_end, panicmsg_end.len)
    discard sleep(1); sync()


proc regSigHandler*() =
    var signals: SigSet
    var dud_signals: SigSet
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
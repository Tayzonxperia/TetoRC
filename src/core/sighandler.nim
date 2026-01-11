import posix, syscall

when not defined(debug):
    {.push optimization:speed, checks:off, warnings:off.}
    # Use these regardless of what is defined, apart from debug



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
    var 
        sigchld_rec* {.volatile.}: Sig_atomic
        sigint_rec* {.volatile.}: Sig_atomic
        sigterm_rec* {.volatile.}: Sig_atomic
        unk_sig_rec* {.volatile.}: Sig_atomic

when defined(daemon):
    proc initSigHandler(
        signum: cint,
        info: ptr Siginfo,
        uctx: pointer)
        {.cdecl, noconv.} =
        case signum:
        of SIGCHLD:
            sigchld_rec = 1
        of SIGINT:
            sigint_rec = 1
        of SIGTERM:
            sigterm_rec = 1
        else:
            unk_sig_rec = 1


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
        when not defined(debug):
                if idx >= 8:
                    safePrint(Print, "%s:  %s\n", reg, cstring($g[idx])) 
        else:
            safePrint(Print, "%s:  %s\n", reg, cstring($g[idx])) 

    #[ Making g[idx] a string is a dirty hack, I can't figure out how to
       make %d handle large numbers, so fuck it, we use a (c)string ]#

    safePrint(Print, "</TASK>\n(,,>﹏<,,)%s\n", RESET)
    discard sleep(1); sync(); discard syscall(EXIT, 1) 


func regSigHandler*()
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
        sa.sa_sigaction = initSigHandler
        discard sigaction(SIGCHLD, sa, nil)
        discard sigaction(SIGINT, sa, nil)
        discard sigaction(SIGTERM, sa, nil)
    
    sa.sa_sigaction = initPanicHandler
    discard sigaction(SIGSEGV, sa, nil)
    discard sigaction(SIGABRT, sa, nil)
    discard sigaction(SIGILL, sa, nil)
    discard sigaction(SIGFPE, sa, nil)

when defined(daemon):
    proc handleChildren*()
        {.inline.} = 
        
        while true:
            var fake_null: cint = 0
            var pid: Pid = waitpid(-1, fake_null,  WNOHANG)
            if pid == 0:
                break
            elif pid == -1:
                if errno == ECHILD:
                    break
                safePrint(Print, "%s(Error)%s TetoRC - waitpid() failed on child: %d", RED, RESET, pid)

        #[ We need a fake NULL because in C, NULL is a macro that
           expands to ((void*)0), but Nim's Nil is a pointer to 
           nothing, so we need a dud interger ... ]#

when not defined(debug):
    {.pop.}
import posix

import "../ffi/spawn"
import "fancy_output"

## START ##
###########



proc posixSpawn*(cmd: cstring, args: varargs[cstring]): cint =
    var pid: Pid
    var argv: seq[cstring]
    argv.add(cmd)
    for arg in args:
        argv.add(arg)
    argv.add(nil)

    let ret = posix_spawn(
    addr pid, cmd, nil, nil,
    cast[ptr ptr cchar](argv[0].addr),
    cast[ptr ptr cchar](nil))

    if ret == 0:
        logDebug("posixSpawn returned " & ret)
        var status: cint
        discard waitpid(pid, status, 0.cint)
        logDebug("Waiting for " & $pid & "(" & $status & ")")
        return status
    else:
        return ret
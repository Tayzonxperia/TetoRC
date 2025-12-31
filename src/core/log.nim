import posix, strformat, times

import "../data/constants", "error"


## START ##
###########

type LogReason = enum
    Info, # Generic message
    Success, # Init completed something
    Warn, # Issue encountered but resolved
    Error, # Error took place
    Debug # Debug event

proc procLog*(msg: string, reason: LogReason, output: File) =
    var prefix = ""

    case reason
    of Info:
        prefix = ("[ " & BOLD & "INFO" & RESET & " ]")
    of Success:
        prefix = ("[ " & BRIGHT_GREEN & "OKAY" & RESET & " ]")
    of Warn:
        prefix = ("[ " & BRIGHT_YELLOW & "WARN" & RESET & " ]")
    of Error:
        prefix = ("[ " & BRIGHT_RED & "FAIL" & RESET & " ]")
    of Debug:
        prefix = ("[ " & BRIGHT_CYAN & "DEBUG" & RESET & " ]")

    let timestamp = cputime()

    if output == stdout:
        stdout.write(fmt"{prefix} {msg} [{timestamp}]" & "\n")
    elif output == stderr:
        stderr.write(fmt"{prefix} {msg} [{timestamp}]" & "\n")
    else:
        stdout.write(fmt"{prefix} {msg} [{timestamp}]" & "\n")

template logInfo*(msg:string) =
    procLog(msg, Info, stdout)

template logSuccess*(msg: string) =
    procLog(msg, Success, stdout)

template logWarn*(msg: string) =
    procLog(msg, Warn, stdout)

template logError*(msg: string) =
    procLog(msg, Error, stderr)

template logDebug*(msg: string) =
    when defined debug:
        procLog(msg, Debug, stdout)
    else:
        discard

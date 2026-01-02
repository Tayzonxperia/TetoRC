import posix, strformat, times

import "../data/constants"


## START ##
###########

type OutputReason = enum
    Info, # Generic message
    Success, # Init completed something
    Warn, # Issue encountered but resolved
    Error, # Error took place
    Debug # Debug event

proc procLog(msg: string, reason: OutputReason, output: File) =
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

    if output == stderr:
        stderr.write(fmt"{prefix} {msg} [{timestamp}]" & "\n")
    else:
        stdout.write(fmt"{prefix} {msg} [{timestamp}]" & "\n")

template logInfo*[T](msg: T) =
    when T is string:
        let conv = msg
    elif T is cstring:
        let conv = $msg
    procLog(conv, Info, stdout)

template logSuccess*[T](msg: T) =
    when T is string:
        let conv = msg
    elif T is cstring:
        let conv = $msg
    procLog(conv, Success, stdout)

template logWarn*[T](msg: T) =
    when T is string:
        let conv = msg
    elif T is cstring:
        let conv = $msg
    procLog(conv, Warn, stdout)

template logError*[T](msg: T) =
    when T is string:
        let conv = msg
    elif T is cstring:
        let conv = $msg
    procLog(conv, Error, stderr)

template logDebug*[T](msg: T) =
    when T is string:
        let conv = msg
    elif T is cstring:
        let conv = $msg
    when defined debug:
        procLog(conv, Debug, stdout)
    else:
        discard


proc procPrint(msg: cstring, reason: OutputReason, output: File) =
    var prefix: cstring = ""

    case reason
    of Info:
        prefix = (BOLD & "==>" & RESET)
    of Success:
        prefix = (BRIGHT_GREEN & "==>" & RESET)
    of Warn:
        prefix = (BRIGHT_YELLOW & "==>" & RESET)
    of Error:
         prefix = (BRIGHT_RED & "==>" & RESET)
    of Debug:
        prefix = (BRIGHT_CYAN & "==>" & RESET)

    if output == stderr:
        stdout.write(fmt"{prefix} {msg}" & "\n")
    else:
        stdout.write(fmt"{prefix} {msg}" & "\n")
                
template printInfo*[T](msg: T) =
    when T is string:
        let conv = msg
    elif T is cstring:
        let conv = $msg
    procPrint(conv, Info, stdout)

template printSuccess*[T](msg: T) =
    when T is string:
        let conv = msg
    elif T is cstring:
        let conv = $msg
    procPrint(conv, Success, stdout)

template printWarn*[T](msg: T) =
    when T is string:
        let conv = msg
    elif T is cstring:
        let conv = $msg
    procPrint(conv, Warn, stdout)

template printError*[T](msg: T) =
    when T is string:
        let conv = msg
    elif T is cstring:
        let conv = $msg
    procPrint(conv, Error, stderr)

template printDebug*[T](msg: T) =
    when defined(debug):
        when T is string:
            let conv = msg
        elif T is cstring:
            let conv = $msg
        procPrint(conv, Debug, stdout)
    else:
        discard
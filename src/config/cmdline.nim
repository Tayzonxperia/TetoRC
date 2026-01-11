import posix, strutils, os
import "../utils/stringops"



const CMDLINE_PATH: string = "/proc/cmdline" 

type ProcCmdlineEntry* = object
    rawCmdline*, stageTwoPath*, execPath*: string
    fstab*: bool

const PROC_CMDLINE_TARGETS = [
    (setter: proc(res: var ProcCmdlineEntry, value: string) = res.stageTwoPath = value, target: "tetorc.stage2="),
    (setter: proc(res: var ProcCmdlineEntry, value: string) = res.execPath = value, target: "tetorc.exec=")
]


proc parseProcCmdline*[T](cmdline: T = CMDLINE_PATH): ProcCmdlineEntry =
    when T is cstring:
        let path = string(cmdline)
    elif T is string:
        let path = cmdline
    else:
        static: assert false, "parseProcCmdline() proc only supports cstring or string"

    if not fileExists(path):
        return

    # Cache data so we don't need to re-read later
    let data = readFile(path)
    result.rawCmdline = data


    for token in data.splitWhitespace:
        for entry in PROC_CMDLINE_TARGETS:
            if token.startsWith(entry.target):
                entry.setter(result, stripPrefix(token, entry.target))
        if token.startsWith("tetorc.fstab"):
            result.fstab = true
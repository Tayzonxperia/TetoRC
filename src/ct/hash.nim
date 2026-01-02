import posix, strutils, tables

import "logger"


## START ##
###########


type HASHspec* = object 
    hash*, hasher*: string

const SCRIPT = "bash ../../scripts/hash.sh"

proc buildHASHspecification(raw: string): HASHspec {.compileTime.} =
    var hashinfo = initTable[string, string]()
    ctTrace("Building HASH")
    for line in raw.splitLines():
        if line.contains("="):
            let parts = line.split("=", maxsplit = 1)
            hashinfo[parts[0].strip()] = parts[1].strip()

            result.hash        = hashinfo.getOrDefault("hash", "")
            result.hasher      = hashinfo.getOrDefault("hasher", "")

const HASH* = buildHASHspecification(staticexec(SCRIPT))

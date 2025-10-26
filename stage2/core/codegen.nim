######## Compiler code generation file
import posix, os, strutils, tables

## Include imports
import "../include/dposix"



#### Defined constants and lets ####
####################################

## Escape codes
const
    RESET* = "\x1b[0m"
    BOLD* = "\x1b[1m"
    RED* =  "\x1b[31m"
    GREEN* = "\x1b[32m"
    YELLOW* = "\x1b[33m"
    BLUE* = "\x1b[34m"
    MAGENTA* = "\x1b[35m"
    CYAN* = "\x1b[36m"
    WHITE* = "\x1b[37m"
    BRIGHT_RED* = "\x1b[91m"
    BRIGHT_GREEN* = "\x1b[92m"
    BRIGHT_YELLOW* = "\x1b[93m"
    BRIGHT_BLUE* = "\x1b[94m"
    BRIGHT_MAGENTA* = "\x1b[95m"
    BRIGHT_CYAN* = "\x1b[96m"
    BRIGHT_WHITE* = "\x1b[97m"

## Animation chars
const SPINNERANIMATION* = ["|", "/", "-", "\\"]

## Mountchecker termination paths
const FAILPATH* = @["/", "/dev", "/proc"]

## File placements
when defined(debug):
    const TMPVERSIONFILE = "version.tmp"
else:
    const VERSIONFILE = "../version.txt"

## Map of all BITWISE flags 
var OPT_MAP* = initTable[string, uint]()
OPT_MAP["MS_RDONLY"] = MS_RDONLY
OPT_MAP["MS_NOSUID"] = MS_NOSUID
OPT_MAP["MS_NODEV"] = MS_NODEV
OPT_MAP["MS_NOEXEC"] = MS_NOEXEC
OPT_MAP["MS_SYNCHRONOUS"] = MS_SYNCHRONOUS
OPT_MAP["MS_REMOUNT"] = MS_REMOUNT
OPT_MAP["MS_MANDLOCK"] = MS_MANDLOCK
OPT_MAP["MS_DIRSYNC"] = MS_DIRSYNC
OPT_MAP["MS_NOSYMFOLLOW"] = MS_NOSYMFOLLOW
OPT_MAP["MS_NOATIME"] = MS_NOATIME
OPT_MAP["MS_NODIRATIME"] = MS_NODIRATIME
OPT_MAP["MS_BIND"] = MS_BIND
OPT_MAP["MS_MOVE"] = MS_MOVE
OPT_MAP["MS_REC"] = MS_REC
OPT_MAP["MS_SILENT"] = MS_SILENT
OPT_MAP["nil"] = 0'u32


#### Compiler codegenerator ####
################################

static:
    echo(BOLD & "Compiling TetoRC at " & RESET & BRIGHT_BLUE & CompileTime & " ~ " & CompileDate & RESET)
    echo(BOLD & "Computing compiler code..." & RESET)

    ## Debug mode
    when defined(debug): # Debug mode adds version tracking
        echo(BRIGHT_GREEN & "---> " & RESET & "Computing version number...")
        var versionfile:string
        when fileexists("../version.txt"):
            versionfile = "../version.txt"
        elif fileexists("version.txt"):
            versionfile = "version.txt"
        else:
            versionfile = "null"
        var ver: int
        if versionfile != "null":
            ver = parseint(readfile(versionfile).strip())
            ver.inc
            writefile(versionfile, $ver)
        else:
            echo(BRIGHT_RED & "---X " & RESET & "Version files not found! Using default version 0 \n You must create your own version.txt to use this feature")
            ver = 0
        let VERSIONFILE = versionfile
        let VERTMP = readfile(VERSIONFILE.strip())    
        writefile(TMPVERSIONFILE, VERTMP)
        echo(BOLD & "TetoRC: #" & RESET & BRIGHT_MAGENTA & VERTMP & RESET & BRIGHT_CYAN & " compiling..." & RESET)
    else:
        echo(BOLD & "TetoRC " & RESET & BRIGHT_CYAN & "compiling..." & RESET)
    

#### Computed constants and lets ####
#####################################

## Version
when defined(debug):
    const TETVER* = static readfile(TMPVERSIONFILE.strip())
else:
    const TETVER* = static readfile(VERSIONFILE.strip())
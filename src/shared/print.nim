import posix, strutils, strformat, errorcodes
import "error"


const
    CLEAR*           = "\e[2J\e[H"
    RESET*           = "\x1b[0m"
    BOLD*            = "\x1b[1m"
    RED*             =  "\x1b[31m"
    GREEN*           = "\x1b[32m"
    YELLOW*          = "\x1b[33m"
    BLUE*            = "\x1b[34m"
    MAGENTA*         = "\x1b[35m"
    CYAN*            = "\x1b[36m"
    WHITE*           = "\x1b[37m"
    BRIGHT_RED*      = "\x1b[91m"
    BRIGHT_GREEN*    = "\x1b[92m"
    BRIGHT_YELLOW*   = "\x1b[93m"
    BRIGHT_BLUE*     = "\x1b[94m"
    BRIGHT_MAGENTA*  = "\x1b[95m"
    BRIGHT_CYAN*     = "\x1b[96m"
    BRIGHT_WHITE*    = "\x1b[97m"

type 
    LogSink* = enum
        Console, Kernel, File
    
    LogStage* = enum
        Pre, Mid, Post

    LogEntry* = object
        msg, context: string
        errorcode: ErrorCode

func makeLog(error: Error, errorcode: ErrorCode): LogEntry =
    var prefix: string

    case error.crit
    of Fatal:
        prefix = "[{BRIGHT_RED}FAIL{RESET}]"
    of Recoverable:
        prefix = "[{BRIGHT_YELLOW}RECO{RESET}]"
    of Warning:
        prefix = "[{]"
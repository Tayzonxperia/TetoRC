import posix, errorcodes



# ErrorCode -> Criticallity -> Error #
type 
    Criticallity* = enum
        Fatal,
        Recoverable,
        Warning,
        Success

    Event* = object
        msg*, context*: string
        crit*: Criticallity
        retry*: bool


func errorCodeToError*(errorcode: ErrorCode): Criticallity =
    case errorcode
    of OutOfMemError, DiskFullError, SegFault, DiskCorruption, StackOverflow, UnrecoverableState, Failure, PermissionDenied, FormatMismatch, BadExecutable:
        return Fatal
    of OverflowError, IndexError, RangeError, IOError:
        return Recoverable
    of KeyError, ValueError, SyntaxError:
        return Warning
    else:
        return Success

proc handleError*(error: Error) =
    case error.crit:
    of Fatal:
        discard
    of Recoverable:
        discard
    of Warning:
        discard
    of Success:
        discard

import posix, syscall

import "../ffi/printf"

## START ##
###########

type SnType* = enum
    Trace, Print

type FileDesc* = distinct int

const 
    STDOUT_fd* = FileDesc(STDOUT_FILENO) 
    STDERR_fd* = FileDesc(STDERR_FILENO)
    STDIN_fd* = FileDesc(STDIN_FILENO) 
    #[ This is needed so we can use 
       distinct FD's, and not fuck
       up the varargs[untyped]... 
       tch its messy, but it shall
       suffice... hopefully ]#

template snPrint*(
    fd: FileDesc,
    fmt: untyped,
    args: varargs[untyped])
    = 
    var buf: array[256, char]
    block A:
        let size = snprintf(addr buf[0], csize_t(buf.len), fmt, args)
        if size >= buf.len or size < 0:
            const msg: cstring = "(Error) Logbuffer overflow\n"
            discard syscall(WRITE, fd, msg, cint(msg.len))
            break A
        discard syscall(WRITE, fd, addr buf[0], cint(size))


template snTrace*(
    fd: FileDesc,
    fmt: untyped,
    args: varargs[untyped])
    =
    var buf: array[2048, char]
    block A:
        let size = snprintf(addr buf[0], csize_t(buf.len), fmt, args)
        if size >= buf.len or size < 0:
            const msg: cstring = "(Error) Logbuffer overflow\n"
            discard syscall(WRITE, fd, msg, msg.len)
            break A
        discard syscall(WRITE, fd, addr buf[0], csize_t(size))

#[ Yes all these overload templates are not really needed...
   but my fucking fingers, these make is so i don't have 
   to specify each damn time... ]#

template safePrint*(
    print_type: SnType,
    fd: FileDesc,
    fmt: untyped,
    args:varargs[untyped])
    =
    case print_type 
    of Print:
        snPrint(fd, fmt, args)
    of Trace:
        snTrace(fd, fmt, args)

template safePrint*(
    print_type: SnType,
    fmt: untyped,
    args: varargs[untyped])
    =
    case print_type 
    of Print:
        snPrint(STDOUT_fd, fmt, args)
    of Trace:
        snTrace(STDOUT_fd, fmt, args)

template safePrint*(
    print_type: SnType,
    fmt: varargs[untyped])
    =
    case print_type 
    of Print:
        snPrint(STDOUT_fd, fmt, nil)
    of Trace:
        snTrace(STDOUT_fd, fmt, nil)


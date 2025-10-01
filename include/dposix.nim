import posix # Imports

## Mount
proc mount*(source: cstring, target: cstring, fstype: cstring, flag: uint, data: pointer): cint {.cdecl, importc: "mount".}

## Umount
proc umount*(target: cstring): cint {.cdecl importc: "umount".}

## Flags for mount 
const   
        MS_RDONLY* = 1'u32
        MS_NOSUID* = 2'u32
        MS_NODEV* = 4'u32
        MS_NOEXEC* = 8'u32
        MS_SYNCHRONOUS* = 16'u32
        MS_REMOUNT* = 32'u32
        MS_MANDLOCK* = 64'u32
        MS_DIRSYNC* = 128'u32
        MS_NOSYMFOLLOW* = 256'u32
        MS_NOATIME* = 1024'u32
        MS_NODIRATIME* = 2048'u32
        MS_BIND* = 4096'u32
        MS_MOVE* = 8192'u32
        MS_REC* = 16384'u32
        MS_SILENT* = 32768'u32

## Swapon
proc swapon*(path: cstring, flags: cint): cint {.cdecl, importc: "swapon" header: "<sys/swap.h>".}

## Swapoff
proc swapoff*(path: cstring): cint {.cdecl, importc: "swapoff", header: "<sys/swap.h>".}

## Type for fileops
type
        ssize_t* = int64

## Open
proc open*(pathname: cstring, flags: cint, mode: cint): cint {.cdecl, importc: "open".}

## Close
proc close*(fd: cint): cint {.cdecl, importc: "close".}

## Read
proc read*(fd: cint, buf: pointer, count: cuint): ssize_t {.cdecl, importc: "read".}

## Write
proc write*(fd: cint, buf: cstring, count: cuint): ssize_t {.cdecl, importc: "write".}

## Fstat
proc fstat*(fd: cint, buf: ptr Stat): cint {.cdecl, importc: "fstat".}

## Unlink
proc unlink*(pathname: cstring): cint {.cdecl, importc: "unlink".}

## Stat (Already defined, needs this var)
var st*:Stat

## Kill
proc kill*(pid: cint, sig: cint): cint {.cdecl, importc: "kill".}

## Waitpid
proc waitpid*(pid_t: cint, status: ptr cint, options: cint): cint {.cdecl, importc: "waitpid", header: "<sys/wait.h>".}

## SIG flags
const
        SIGKILL*:cint = 9
        SIGTERM*:cint = 15
        SIGCHLD*:cint = 17
        SIGUSR1*:cint = 10
        SIGUSR2*:cint = 12

## Common waitpid flags
const
        WNOHANG*:cint = 1
        WUNTRACED*:cint = 2

## Sync
proc sync*() {.importc: "sync", cdecl.}

## Reboot
proc reboot*(flag: cint) {.importc: "reboot", cdecl.}

## Reboot flags
const
        LINUX_REBOOT_CMD_POWER_OFF* = 0x4321FEDC
        LINUX_REBOOT_CMD_RESTART* = 0x1234567

## Execve
#proc execve*(path: cstring, argv: ptr cstringArray, envp: ptr cstringArray): cint {.importc: "execve", cdecl.}

## Uname
proc uname*(buf: ptr UtsName): cint {.importc, header: "<sys/utsname.h>".}

## Var for uname
var u*: UtsName

## Type for uname
type
        UtsName* {.importc: "struct utsname", header: "<sys/utsname.h>".} = object
                sysname*, nodename*, release*, version*, machine*: array[0..64, char]
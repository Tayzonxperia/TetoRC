######## Compiler code generation file
import posix, os, strutils

## Include imports
import "../../include/dposix"



#### Defined constants and lets ####
####################################

## Stage define
const STAGE* = "1"

## Escape codes
const
    CLEAR* = "\e[2J\e[H"
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

## Mountchecker termination paths
const FAILPATH* = @["/", "/dev", "/proc"]

## Safe mount options
const
    PROC_SRC*:cstring = "procfs"
    SYS_SRC*:cstring = "sysfs"
    DEV_SRC*:cstring = "devfs"
    RUN_SRC*:cstring = "runfs"
    TMP_SRC*:cstring = "tmpfs"

    PROC_FS*:cstring = "proc" 
    SYS_FS*:cstring = "sysfs"
    DEV_FS*:cstring = "devtmpfs"
    RUN_FS*:cstring = "tmpfs"
    TMP_FS*:cstring = "tmpfs"

    PROC_PATH*:cstring = "/proc"
    SYS_PATH*:cstring = "/sys"
    DEV_PATH*:cstring = "/dev"
    RUN_PATH*:cstring = "/run"
    TMP_PATH*:cstring = "/tmp"

    PROC_FS_OPT*:cstring = ""
    SYS_FS_OPT*:cstring = ""
    DEV_FS_OPT*:cstring = ""
    RUN_FS_OPT*:cstring = "size=128M,mode=755,inode64"
    TMP_FS_OPT*:cstring = "size=512M,mode=1777"

    PROC_FS_MNT* = MS_NOSUID or MS_NOEXEC or MS_NODEV
    SYS_FS_MNT* = MS_NOSUID or MS_NOEXEC or MS_NODEV
    DEV_FS_MNT* = 0'u32
    RUN_FS_MNT* = MS_NOSUID or MS_NODEV or MS_NODIRATIME
    TMP_FS_MNT* = MS_NOSUID or MS_NODEV or MS_NOATIME

## Enums
type mountcheckRESULT* = enum
    Mounted, NotMounted, MountNotCheckable

type
  VFSInfo* = object
    path*: string           # path probed
    fsid*: uint64          # filesystem ID
    blockSize*: c_ulong     # fundamental block size
    fragmentSize*: c_ulong  # fragment size
    totalBlocks*: c_ulong   # total number of blocks
    freeBlocks*: c_ulong    # free blocks
    availBlocks*: c_ulong   # blocks available to non-root
    totalInodes*: c_ulong   # total inodes
    freeInodes*: c_ulong    # free inodes
    availInodes*: c_ulong   # inodes available to non-root
    mountReadOnly*: bool    # true if FS is read-only

#### Compiler codegenerator ####
################################

static:
    echo(BOLD & "Compiling TetoRC (Stage " & $STAGE & ") at " & RESET & BRIGHT_BLUE & CompileTime & " ~ " & CompileDate & RESET)
    if defined(danger):
        echo(BRIGHT_YELLOW & "---# " & RESET & YELLOW & "Warning: " & RESET & "Danger mode enabled! Runtime checking off!")
    if defined(gcoff):
        echo(BRIGHT_RED & "---! " & RESET & RED & "Warning: " & RESET & "Garbage collecter disabled! Segfaults possible!")

    echo(BOLD & "Determining if we are linking staticlly or shared..." & RESET)
    if defined(static):
        echo(BRIGHT_GREEN & "---> " & RESET & "Link state: Static")
    elif defined(shared):
        echo(BRIGHT_GREEN & "---> " & RESET & "Link state: Shared")
    
    echo(BOLD & "Computing compiler code..." & RESET)

    echo(BRIGHT_GREEN & "---> " & RESET & "Computing mount tables...")
    

#### Computed constants and lets ####
#####################################

const TETVER*:string = static: readfile("../version.txt").strip()
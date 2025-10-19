import posix 

import runtime 

## Program hardcodes

const
    TETVER*:cstring = "0.999.0"


## Paths
 
let
    ROOTFS_PATH*:cstring = "/"
    PROC_PATH*:cstring = "/proc"
    SYS_PATH*:cstring = "/sys"
    DEV_PATH*:cstring = "/dev"
    DEVPTS_PATH*: cstring = "/dev/pts"
    RUN_PATH*:cstring = RUNSTATEDIR #(/run)
    TMP_PATH*:cstring = "/tmp"
    SHM_PATH*:cstring = "/dev/shm"
    SECURITY_PATH*:cstring = "/sys/kernel/security"
    CGROUPS2_PATH*:cstring = "/sys/fs/cgroup"
    KASANE_PATH*:cstring = "/kasane"

## Filesystems
 
let
    ROOTFS_FS*:cstring = "ext4"
    PROC_FS*:cstring = "proc"
    SYS_FS*:cstring = "sysfs"
    DEV_FS*: cstring = "devtmpfs"
    DEVPTS_FS*:cstring = "devpts"
    RUN_FS*:cstring = "tmpfs"
    TMP_FS*:cstring = "tmpfs"
    SHM_FS*:cstring = "tmpfs"
    SECURITY_FS*:cstring = "securityfs"
    CGROUPS2_FS*:cstring = "cgroup2"
    KASANE_FS*:cstring = "ext4"

## Sources
 
let
    ROOTFS_SRC*:cstring = "/dev/sda1"
    PROC_SRC*:cstring = "procfs"
    SYS_SRC*:cstring = "sysfs"
    DEV_SRC*:cstring = "devfs"
    DEVPTS_SRC*:cstring = "devptsfs"
    RUN_SRC*:cstring = "runfs"
    TMP_SRC*:cstring = "tmpfs"
    SHM_SRC*:cstring = "shmfs"
    SECURITY_SRC*:cstring = "securityfs"
    CRGOUPS2_SRC*:cstring = "cgroup2fs"
    KASANE_SRC*:cstring = "/dev/sda2"

    SWAP_1*:cstring = "/dev/sda3"



#### mountcheck() hardcodes

## Enums

type mountcheckRESULT* = enum
    Mounted, NotMounted, MountNotCheckable

## Options

const 
    failpath* = @["/", "/dev", "/proc"]

#### Escape codes

## Misc

const
    RESET* = "\x1b[0m"
    BOLD* = "\x1b[1m"

## Main colors

const
    RED* =  "\x1b[31m"
    GREEN* = "\x1b[32m"
    YELLOW* = "\x1b[33m"
    BLUE* = "\x1b[34m"
    MAGENTA* = "\x1b[35m"
    CYAN* = "\x1b[36m"
    WHITE* = "\x1b[37m"

## Bright colors

const
    BRIGHT_RED* = "\x1b[91m"
    BRIGHT_GREEN* = "\x1b[92m"
    BRIGHT_YELLOW* = "\x1b[93m"
    BRIGHT_BLUE* = "\x1b[94m"
    BRIGHT_MAGENTA* = "\x1b[95m"
    BRIGHT_CYAN* = "\x1b[96m"
    BRIGHT_WHITE* = "\x1b[97m"

## Spinner settings

const spinneranimation* = ["|", "/", "-", "\\"]

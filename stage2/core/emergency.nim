######## TetoRC emergency procedure file
import posix, os, strutils, tables

## Include imports
import "../include/dposix"

## Project imports
import "codegen", "runtime", "../fs/mount"


### Isolated constants ###
##########################

const
    E_PROC_SRC:cstring = "procfs"
    E_SYS_SRC:cstring = "sysfs" 
    E_DEV_SRC:cstring = "devtmpfs"
    E_RUN_SRC:cstring = "tmpfs"
    E_TMP_SRC:cstring = "tmpfs"

const
    E_PROC_FS:cstring = "proc"
    E_SYS_FS:cstring = "sysfs"
    E_DEV_FS:cstring = "devtmpfs"
    E_RUN_FS:cstring = "tmpfs"
    E_TMP_FS:cstring = "tmpfs"

const
    E_PROC_PATH:cstring = "/proc"
    E_SYS_PATH:cstring = "/sys"
    E_DEV_PATH:cstring = "/dev"
    E_RUN_PATH:cstring = "/run"
    E_TMP_PATH:cstring = "/tmp"

const
    E_PROC_FS_OPT:cstring = ""
    E_SYS_FS_OPT:cstring = ""
    E_DEV_FS_OPT:cstring = ""
    E_RUN_FS_OPT:cstring = ""
    E_TMP_FS_OPT:cstring = ""


let
    E_PROC_FS_MNT:uint = 0
    E_SYS_FS_MNT:uint = 0 
    E_DEV_FS_MNT:uint = 0
    E_RUN_FS_MNT:uint = 0
    E_TMP_FS_MNT:uint = 0
       

### Isolated logic ###
######################

proc emergencydetector*() =
    if EMERGENCY == 1:
        stdout.write(BRIGHT_RED, "#### EMERGENCY MODE #### \n")
        if uname(addr u) == 0:
                stdout.write("\n", BRIGHT_WHITE, "       TetoRC version ",RESET, BRIGHT_MAGENTA, TETVER, RESET, BRIGHT_WHITE, " starting up ",RESET, BOLD, BRIGHT_CYAN, cast[cstring](addr u.sysname[0]), RESET, BOLD," - ", RESET, BOLD, BRIGHT_RED, cast[cstring](addr u.release[0]), RESET, "\n \n")
        else:
            stdout.write("...")
        discard mounter(E_PROC_SRC, E_PROC_PATH, E_PROC_FS, E_PROC_FS_MNT, cast[pointer](E_PROC_FS_OPT))
        discard mounter(E_SYS_SRC, E_SYS_PATH, E_SYS_FS, E_SYS_FS_MNT, cast[pointer](E_SYS_FS_OPT))
        discard mounter(E_RUN_SRC, E_RUN_PATH, E_RUN_FS, E_RUN_FS_MNT, cast[pointer](E_RUN_FS_OPT))
        discard mounter(E_TMP_SRC, E_TMP_PATH, E_TMP_FS, E_TMP_FS_MNT, cast[pointer](E_TMP_FS_OPT))
    else:
        stdout.write(BRIGHT_GREEN, "No errors found! \n", RESET, BOLD, "Continuing...")
        
import posix 

import runtime 

## Paths
 
let
    ROOTFS_PATH*:cstring = "/"
    PROC_PATH*:cstring = "/proc"
    SYS_PATH*:cstring = "/sys"
    DEV_PATH*:cstring = "/dev"
    DEVPTS_PATH*: cstring = "/dev/pts"
    RUN_PATH*:cstring = RUNSTATEDIR 
    TMP_PATH*:cstring = TMPFSDIR
    SHM_PATH*:cstring = "/dev/shm"
    SECURITY_PATH*:cstring = "/sys/kernel/security"
    CGROUPS2_PATH*:cstring = "/sys/fs/cgroup"
    KASANE_PATH*:cstring = "/kasane"

## Filesystems
 
let
    ROOTFS_FS*:cstring = ROOTFS_FSVAR
    PROC_FS*:cstring = "proc"
    SYS_FS*:cstring = "sysfs"
    DEV_FS*: cstring = "devtmpfs"
    DEVPTS_FS*:cstring = "devpts"
    RUN_FS*:cstring = "tmpfs"
    TMP_FS*:cstring = TMP_FSVAR
    SHM_FS*:cstring = "tmpfs"
    SECURITY_FS*:cstring = "securityfs"
    CGROUPS2_FS*:cstring = "cgroup2"
    KASANE_FS*:cstring = KASANE_FSVAR

## Sources
 
let
    ROOTFS_SRC*:cstring = ROOTFS_DEV
    PROC_SRC*:cstring = "procfs"
    SYS_SRC*:cstring = "sysfs"
    DEV_SRC*:cstring = "devfs"
    DEVPTS_SRC*:cstring = "devptsfs"
    RUN_SRC*:cstring = "runfs"
    TMP_SRC*:cstring = "tmpfs"
    SHM_SRC*:cstring = "shmfs"
    SECURITY_SRC*:cstring = "securityfs"
    CRGOUPS2_SRC*:cstring = "cgroup2fs"
    KASANE_SRC*:cstring = KASANE_DEV

    SWAP_1*:cstring = SWAP1_DEV



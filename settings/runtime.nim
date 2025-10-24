#### Imports
import posix
#### Project imports
import "../include/dposix"


## Program params
let
    SYSCONFDIR*:cstring = "/etc"
    RUNSTATEDIR*:cstring = "/run"
    TMPFSDIR*:cstring = "/tmp"

let
    HOSTNAME*:cstring = "EDEIC"
    
## Filesystem options
let
    ROOTFS_FSVAR*:cstring = "ext4"
    TMP_FSVAR*:cstring = "tmpfs"
    KASANE_FSVAR*:cstring = "ext4"

let
    ROOTFS_DEV*:cstring = "/dev/sda1"
    KASANE_DEV*:cstring = "/dev/sda2"
    SWAP1_DEV*:cstring = "/dev/sda3"
let
    proc_options*:cstring = ""
    sys_options*:cstring = ""
    dev_options*:cstring = ""
    devpts_options*:cstring = ""
    run_options*:cstring = "size=128M,mode=755,inode64"
    tmp_options*:cstring = "size=512M,mode=1777"
    shm_options*:cstring = ""
    cgroup2_options*:cstring = ""
    security_options*:cstring = ""
    kasane_options*:cstring = ""

let
    proc_flags* = MS_NOSUID or MS_NOEXEC or MS_NODEV
    sys_flags* = MS_NOSUID or MS_NOEXEC or MS_NODEV
    run_flags* = MS_NOSUID or MS_NODEV or MS_NODIRATIME
    tmp_flags* = MS_NOSUID or MS_NODEV or MS_NOATIME
    kasane_flags* = MS_NOSUID or MS_NODEV or MS_NOATIME

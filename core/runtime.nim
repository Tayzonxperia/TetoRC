######## Runtime state file
import posix, os, strutils, parsecfg

import "codegen"


#### Config loading and parsing

var cfg: Config
when fileexists("/etc/tetorc/teto.ini"):
    cfg = loadconfig("/etc/tetorc/teto.ini")
elif defined(debug):
    cfg = loadconfig("/home/taylor/Code/Builds/Nimboot/core/teto.ini")
else:
    stdout.write(BOLD, "CFG file not found!", RESET)


## Logic for config parsing

let LOGGING_ENABLED* = cfg.getSectionValue("bootoptions", "logging").parse_bool
let BOOT_MODE* = cfg.getSectionValue("bootoptions", "mode")

## Device mode lets (TODO: Loop these)

let
    ROOT_SRC* = cfg.getSectionValue("devices_src", "root")
    PROC_SRC* = cfg.getSectionValue("devices_src", "proc")
    SYS_SRC* = cfg.getSectionValue("devices_src", "sys")
    DEV_SRC* = cfg.getSectionValue("devices_src", "dev")
    RUN_SRC* = cfg.getSectionValue("devices_src", "run")
    TMP_SRC* = cfg.getSectionValue("devices_src", "tmp")
    KASANE_SRC* = cfg.getSectionValue("devices_src", "kasane")

let
    ROOT_FS* = cfg.getSectionValue("devices_fs", "root")
    PROC_FS* = cfg.getSectionValue("devices_fs", "proc")
    SYS_FS* = cfg.getSectionValue("devices_fs", "sys")
    DEV_FS* = cfg.getSectionValue("devices_fs", "dev")
    RUN_FS* = cfg.getSectionValue("devices_fs", "run")
    TMP_FS* = cfg.getSectionValue("devices_fs", "tmp")
    KASANE_FS* = cfg.getSectionValue("devices_fs", "kasane")

let
    ROOT_PATH* = cfg.getSectionValue("devices_path", "root")
    PROC_PATH* = cfg.getSectionValue("devices_path", "proc")
    SYS_PATH* = cfg.getSectionValue("devices_path", "sys")
    DEV_PATH* = cfg.getSectionValue("devices_path", "dev")
    RUN_PATH* = cfg.getSectionValue("devices_path", "run")
    TMP_PATH* = cfg.getSectionValue("devices_path", "tmp")
    KASANE_PATH* = cfg.getSectionValue("devices_path", "kasane")

let 
    ROOT_FS_OPT* = cfg.getSectionValue("filesystem_options", "root")
    PROC_FS_OPT* = cfg.getSectionValue("filesystem_options", "proc")
    SYS_FS_OPT* = cfg.getSectionValue("filesystem_options", "sys")
    DEV_FS_OPT* = cfg.getSectionValue("filesystem_options", "dev")
    RUN_FS_OPT* = cfg.getSectionValue("filesystem_options", "run")
    TMP_FS_OPT* = cfg.getSectionValue("filesystem_options", "tmp")
    KASANE_FS_OPT* = cfg.getSectionValue("filesystem_options", "kasane")

let
    ROOT_FS_MNT* = cfg.getSectionValue("mount_flags", "root")
    PROC_FS_MNT* = cfg.getSectionValue("mount_flags", "proc")
    SYS_FS_MNT* = cfg.getSectionValue("mount_flags", "sys")
    DEV_FS_MNT* = cfg.getSectionValue("mount_flags", "dev")
    RUN_FS_MNT* = cfg.getSectionValue("mount_flags", "run")
    TMP_FS_MNT* = cfg.getSectionValue("mount_flags", "tmp")
    KASANE_FS_MNT* = cfg.getSectionValue("mount_flags", "kasane")
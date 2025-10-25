######## Runtime state file
import posix, os, strutils, tables, parsecfg

import "../include/dposix"

import "codegen"


#### Config loading and parsing

# Load teto.ini
var cfg*: Config
if fileexists("/etc/tetorc/teto.ini"):
    cfg = loadconfig("/etc/tetorc/teto.ini")
elif defined(debug) and fileexists("/home/taylor/Code/Builds/Nimboot/core/teto.ini"):
    cfg = loadconfig("/home/taylor/Code/Builds/Nimboot/core/teto.ini")
else:
    quit(BRIGHT_RED & "INI file not found!"& RESET)

# Load mount.cfg
var mountcfg*: string
if fileexists("/etc/tetorc/mount.cfg"):
    mountcfg = "/etc/tetorc/mount.cfg"
elif defined(debug) and fileexists("/home/taylor/Code/Builds/Nimboot/core/mount.cfg"):
    mountcfg = "/home/taylor/Code/Builds/Nimboot/core/mount.cfg"
else:
    quit(BRIGHT_RED & "Mount CFG file not found!" & RESET)


## Parsing

proc parseMountExpr(expr: string): uint32 =
  let CLEANED = expr.strip(chars = {'"', ' '})  
  if CLEANED == "nil" or CLEANED.len == 0:
    return 0'u32

  var result: uint32 = 0
  for token in CLEANED.split("or"):
    let FLAG = token.strip()
    if OPT_MAP.contains(FLAG):
      result = result.uint32 or OPT_MAP[FLAG].uint32
    else:
      stdout.write("Unknown flag: ", FLAG)
  return result

var mntflags* = initTable[string, uint32]()
for line in readfile(mountcfg).splitlines():
  let trimmed = line.strip()
  if trimmed.len == 0 or trimmed.startswith(";"): continue  
  let parts = trimmed.split('=', 2)
  if parts.len == 2:
    let path = parts[0].strip(chars = {'"', ' '})
    let expr = parts[1].strip()
    mntflags[path] = parseMountExpr(expr)


## Main lets

let
    PROC_SRC*:cstring = cfg.getSectionValue("devices_src", "proc").strip().cstring
    SYS_SRC*:cstring = cfg.getSectionValue("devices_src", "sys").strip().cstring
    DEV_SRC*:cstring = cfg.getSectionValue("devices_src", "dev").strip().cstring
    RUN_SRC*:cstring = cfg.getSectionValue("devices_src", "run").strip().cstring
    TMP_SRC*:cstring = cfg.getSectionValue("devices_src", "tmp").strip().cstring
    KASANE_SRC*:cstring = cfg.getSectionValue("devices_src", "kasane").strip().cstring

let
    PROC_FS*:cstring = cfg.getSectionValue("devices_fs", "proc").strip().cstring
    SYS_FS*:cstring = cfg.getSectionValue("devices_fs", "sys").strip().cstring
    DEV_FS*:cstring = cfg.getSectionValue("devices_fs", "dev").strip().cstring
    RUN_FS*:cstring = cfg.getSectionValue("devices_fs", "run").strip().cstring
    TMP_FS*:cstring = cfg.getSectionValue("devices_fs", "tmp").strip().cstring
    KASANE_FS*:cstring = cfg.getSectionValue("devices_fs", "kasane").strip().cstring

let
    PROC_PATH*:cstring = cfg.getSectionValue("devices_path", "proc").strip().cstring
    SYS_PATH*:cstring = cfg.getSectionValue("devices_path", "sys").strip().cstring
    DEV_PATH*:cstring = cfg.getSectionValue("devices_path", "dev").strip().cstring
    RUN_PATH*:cstring = cfg.getSectionValue("devices_path", "run").strip().cstring
    TMP_PATH*:cstring = cfg.getSectionValue("devices_path", "tmp").strip().cstring
    KASANE_PATH*:cstring = cfg.getSectionValue("devices_path", "kasane").strip().cstring

let 
    PROC_FS_OPT*:cstring = cfg.getSectionValue("filesystem_options", "proc").strip().cstring
    SYS_FS_OPT*:cstring = cfg.getSectionValue("filesystem_options", "sys").strip().cstring
    DEV_FS_OPT*:cstring = cfg.getSectionValue("filesystem_options", "dev").strip().cstring
    RUN_FS_OPT*:cstring = cfg.getSectionValue("filesystem_options", "run").strip().cstring
    TMP_FS_OPT*:cstring = cfg.getSectionValue("filesystem_options", "tmp").strip().cstring
    KASANE_FS_OPT*:cstring = cfg.getSectionValue("filesystem_options", "kasane").strip().cstring

let
    PROC_FS_MNT* = mntflags.getOrDefault("/proc", 0'u32)
    SYS_FS_MNT* = mntflags.getOrDefault("/sys", 0'u32)
    DEV_FS_MNT* = mntflags.getOrDefault("/dev", 0'u32)
    DEVPTS_FS_MNT* = mntflags.getOrDefault("/dev/pts", 0'u32)
    RUN_FS_MNT* = mntflags.getOrDefault("/run", 0'u32)
    TMP_FS_MNT* = mntflags.getOrDefault("/tmp", 0'u32)
    SHM_FS_MNT* = mntflags.getOrDefault("/dev/shm", 0'u32)
    CGROUP_FS_MNT* = mntflags.getOrDefault("/sys/fs/cgroup", 0'u32)
    SECURITY_FS_MNT* = mntflags.getOrDefault("/sys/kernel/security", 0'u32)
    KASANE_FS_MNT* = mntflags.getOrDefault("/kasane", 0'u32)

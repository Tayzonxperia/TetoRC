import posix, strutils, os
import "../config/cmdline"



const
    FSTAB_PATH: string = "/etc/fstab"
    MTAB_PATH: string = "/proc/mtab"


type FilesystemTable* = object
    device*, mountpoint*, fstype*, options*: string
    dump*, pass*: int

type FstabCacheState* = enum
    disabled, enabled, unknown 

type MountEntry* = object
    source*, target*, fstype*: cstring
    flags*: culong
    data*: ptr char


var cachedFstab*: FstabCacheState = unknown 

proc cacheCheckFstab*(state: FstabCacheState): bool =
    # If explicitly set, override
    if state != unknown: cachedFstab = state

    # If cached, return
    case cachedFstab
    of enabled: return true
    of disabled: return false
    of unknown: discard

    let value = parseProcCmdline().fstab
    cachedFstab = if value: enabled else: disabled

    # Return a bool, not enum
    return value


template checkFstab*(): bool =
    cacheCheckFstab(unknown)


func isAmbientMount*[T](mnt: T): bool =
    when T is cstring:
        let path = $mnt
    elif T is string:
        let path = mnt
    else:
        static: assert false, "isAmbientMount() func only supports cstring or string"
    if mnt in ["/", "/usr", "/etc"]:
        return true
    if mnt.startsWith("/proc") or
        mnt.startsWith("/sys") or
        mnt.startsWith("/dev") or
        mnt.startsWith("/run/initramfs") or
        mnt.startsWith("/oldroot") or
        mnt.startsWith("/newroot") or
        mnt.startsWith("/run/nextroot"):
            return true
    return false


proc parseFstab[T](fstab: T = FSTAB_PATH): seq[FilesystemTable] =
    when T is cstring:
        let path = $fstab
    elif T is string:
        let path = fstab
    else:
        static: assert false, "parseFstab() proc only supports cstring or string"
    
    var table: seq[FilesystemTable] = @[] 

    if not fileExists(path):
        return table

    for line in lines(path):
        let trimmed = line.strip()
        if trimmed.len == 0 or trimmed.startsWith("#"):
            continue

        let fields = trimmed.splitWhitespace()
        if fields.len < 6:
            continue
        
        let dumpVal = try: parseInt(fields[4]) except CatchableError: 0
        let passVal = try: parseInt(fields[5]) except CatchableError: 0

        table.add(FilesystemTable(
            device:         fields[0],
            mountpoint:     fields[1],
            fstype:         fields[2],
            options:        fields[3],
            dump:           dumpVal,
            pass:           passVal
        ))

    table


proc loadMountTable*(): seq[FilesystemTable] =
    if checkFstab():
        discard

    let fstab = parseFstab()
    if fstab.len == 0:
        return


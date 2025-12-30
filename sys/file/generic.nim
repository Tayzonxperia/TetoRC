import posix

import "statvfs", "data"
import "../../core/log" 


## START ##
###########

proc getVfsInfo*[T](path: T): VfsInfo =
    let cpath =
        when T is string:
            cstring(path)
        elif T is cstring:
            path

    var stat: StatVfs

    let ret = statvfs(cpath, stat)

    result = VfsInfo(
        path:         path,
        fsid:         uint64(stat.f_fsid),
        blockSize:    stat.f_bsize,
        fragmentSize: stat.f_frsize,
        totalBlocks:  stat.f_blocks,
        freeBlocks:   stat.f_bfree,
        availBlocks:  stat.f_bavail,
        totalInodes:  stat.f_files,
        freeInodes:   stat.f_ffree,
        availInodes:  stat.f_favail,
        readOnly:     (stat.f_flag and ST_RDONLY.culong) != 0,
        status:       ret)

proc showVfsInfo*(vfspath: string): string =
    let data = getVfsInfo(vfspath)

    if data.status != 0:
        logWarn("VFS: Failed to stat " & data.path)
    else:
        if data.readOnly:
            logInfo("VFS: " & data.path & " has FSID: " & $data.fsid & " (R/O)")
        else:
            logInfo("VFS: " & data.path & " has FSID: " & $data.fsid & " (R/W)")

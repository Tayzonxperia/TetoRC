######## TetoRC Stage 1 statvfs file
import posix

## Project imports
import "../core/codegen", "../core/msg"



#### vfsinfo proc ####
######################
proc vfsinfo*[T](path: T): VFSInfo =
    var cpath: cstring
    when T is string:
        cpath = cstring(path)
    elif T is cstring:
        cpath = path
    var stat: Statvfs
    let ret = statvfs(cpath, stat)
    if ret != 0:
        tmesg(ret, "VFS: Failed to stat " & $cpath)

    result = VFSInfo(
        path: $cpath,
        fsid: uint64(stat.f_fsid),
        blockSize: stat.f_bsize,
        fragmentSize: stat.f_frsize,
        totalBlocks: stat.f_blocks,
        freeBlocks: stat.f_bfree,
        availBlocks: stat.f_bavail,
        totalInodes: stat.f_files,
        freeInodes: stat.f_ffree,
        availInodes: stat.f_favail,
        mountReadOnly: (stat.f_flag and ST_RDONLY.culong) != 0
        )

    tmesg(0, "VFS: " & $cpath & " mounted with FSID " &
        $result.fsid & ", ro=" & $result.mountReadOnly)
   
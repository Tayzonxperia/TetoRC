import posix

import "mount", "data"
import "../../core/log" 
import "../file/generic"

## START ##
###########


proc mountFilesystem*[T](source, target, fsType: T, flags: uint, data: pointer, mandatory: bool) =
    let csource, ctarget, cfsType, cflags, cdata =
        when T is string:
            cstring(source)
            cstring(target)
            cstring(fsType)
        else:
            source
            target
            fsType

    var already_mounted = false # Assume is isn't

    var current = target
    while current != "/":
        let currentvfs = getVfsInfo(current)
        let parentvfs = getVfsInfo(dirname(current))
        if currentvfs.fsid != parentvfs.fsid:
            var already_mounted = true
        else:
            var already_mounted = false
    
    if not already_mounted:
        let ret = mount(csource, ctarget, cfsType, flags, data) 
        if ret == 0:
            logSuccess("Mount: Mounted " & target & "successfully")
        elif ret != 0 and mandatory:
            logError("Mount: Mounting " & target & "failed!\nAborting to shell...")
            execve("/bin/bash")

    elif already_mounted and mandatory:
        let ret = umount2(ctarget)
        sync()
        if ret == 0:
            mount(csource, ctarget, cfsType, flags, data)
        else:
            logWarn("Mount: Failed to remount " & target & " (Error: " & $oslasterror() & ")")
    
    elif already_mounted and not mandatory:
        logWarn("Mount: Filesystem already mounted, skipping...")
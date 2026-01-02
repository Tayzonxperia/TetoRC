import posix, os

import "../../util/output"


## START ##
###########

proc handlePoweron*() =
    for sh in walkDir("/kasane/teto.d/poweron"):
        if sh.kind == pcFile:
            let name = basename(sh.path.cstring)
            let ret = execl(sh.path.cstring, "poweron", nil)
            if ret == 0:
                logSuccess("Start script: " & $name & " ran successfully")
            else:
                logError("Start script: " & $name & " failed")
        else:
            logError("Start script not a valid file")
    
        

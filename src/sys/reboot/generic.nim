import posix, os, syscall

import "data"
import "../../core/log"


## START ##
###########

proc handleShutdown*(cmd: cstring) =
    case cmd 
    of "shutdown":
        for sh in walkDir("/kasane/teto.d/shutdown"):
            if sh.kind == pcFile:
                let name = basename(sh.path.cstring)
                let ret = execl(sh.path.cstring, "shutdown", nil)
                if ret == 0:
                    logSuccess("Halt script: " & $name & " ran successfully")
                else:
                    logError("Halt script: " & $name & " failed")
            else:
                logError("Halt script not a valid file")
        sync(); sleep(1); discard syscall(REBOOT, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_CMD_POWER_OFF)
        
    of "reboot":
          for sh in walkDir("/kasane/teto.d/reboot"):
            if sh.kind == pcFile:
                let name = basename(sh.path.cstring)
                let ret = execl(sh.path.cstring, "reboot", nil)
                if ret == 0:
                    logSuccess("Halt script: " & $name & " ran successfully")
                else:
                    logError("Halt script: " & $name & " failed")
            sync(); sleep(1); discard syscall(REBOOT, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_CMD_RESTART)
    

        


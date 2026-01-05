import posix, os, syscall

import "data", "../../util/fancy_output"


## START ##
###########

proc handlePoweroff*(cmd: cstring) =
    for sh in walkDir("/kasane/teto.d/poweroff"):
        if sh.kind == pcFile:
            let name = basename(sh.path.cstring)
            let ret = execl(sh.path.cstring, "poweroff", nil)
            if ret == 0:                    
                logSuccess("Poweroff script: " & $name & " ran successfully")
            else:
                logError("Poweroff script: " & $name & " failed")
        else:
            logError("Poweroff script not a valid file")

        logInfo("Sending the TERM signal..."); discard kill(-1, SIGTERM)
        
        var status: cint
        while true:
            let pid = waitpid(-1, status, WNOHANG)
            if (pid == -1 and errno == ECHILD):
                break
    case cmd
    of "shutdown":
        sync(); sleep(1); discard syscall(REBOOT, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_CMD_POWER_OFF)
    of "reboot":
        sync(); sleep(1); discard syscall(REBOOT, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_CMD_RESTART)
    

        

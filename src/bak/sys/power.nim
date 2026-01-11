import posix, os, syscall

import "../../util/fancy_output"


## START ##
###########

const
    LINUX_REBOOT_MAGIC1*       =  0xfee1dead

when not defined(tiny) or not defined(small):
    const
        LINUX_REBOOT_MAGIC2   =  672274793
        LINUX_REBOOT_MAGIC2A  =  85072278
        LINUX_REBOOT_MAGIC2B  =  369367448
        LINUX_REBOOT_MAGIC2C  =  537993216

const 
    LINUX_REBOOT_CMD_RESTART*     = 0x01234567
    LINUX_REBOOT_CMD_HALT*        = 0xCDEF0123
    LINUX_REBOOT_CMD_CAD_ON*      = 0x89ABCDEF
    LINUX_REBOOT_CMD_CAD_OFF*     = 0x00000000   
    LINUX_REBOOT_CMD_POWER_OFF*   = 0x4321FEDC
    LINUX_REBOOT_CMD_RESTART2*    = 0xA1B2C3D4

when defined(suspend):
    const
        LINUX_REBOOT_CMD_SW_SUSPEND*  = 0xD000FCE2
when defined(kexec):
    const
        LINUX_REBOOT_CMD_KEXEC*       = 0x45584543


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
    

        

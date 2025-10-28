######## Main TetoRC Stage 2 file
import posix, os

## Include imports
import "../../include/universal", "../../include/dposix", "../../include/dcustom"

## Project imports
import "codegen", "msg"
import "../fs/vfs", "../fs/mount"
import "../ipc/fifo"

## Project FFI imports
{.compile: "../init/init.c".}
{.compile: "../init/exec.c".}
{.compile: "../init/shutdown.c".}


#### Main function ####
#######################
proc mainfunc() =
    centerText(BOLD & "TetoRC Stage " & STAGE & " is loading ......" & RESET & "\n")

    createdir("/run/tetorc") 
    createdir("/tmp/tetorc")



    initfifo(PIPEINPATH, PIPEOUTPATH)

    cmain()



#### Start of bootstrap ####
############################
mainfunc()


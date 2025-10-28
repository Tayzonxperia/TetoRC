######## TetoRC Stage 1 file ops handler
import posix, os

## Include imports
import "../../include/universal"

## Project imports
import "../core/msg"


#### Directory creator ####
###########################
proc makedir*[T](path: T) =
    var realpath: string
    when T is string:
        realpath = path
    elif T is cstring:
        realpath = string(path)

    if direxists(realpath):
        let successmsg = (realpath & " already exists")
        tmesg(0, successmsg)
    else:
        createdir(realpath)
        if direxists(realpath):
            let successmsg = (realpath & " created")
            tmesg(0, successmsg)
        else:
            let errormsg = (realpath & " could not be created")
            tmesg(0, errormsg)
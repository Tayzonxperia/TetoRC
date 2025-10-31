######## TetoRC Stage 1 hash verification filr
import posix, os

## Include imports
import "../../include/universal", "../../include/dposix"

## Project imports
import "../core/codegen", "../core/msg"
import "../fs/file"


#### Hash writer ####
#####################
proc writehash*() =
    const hashloc = ("/kasane/tetorc/security/hash." & HASH.hasher)
    if fileexists(hashloc):
        let currenthash = readfile(hashloc)
        if currenthash != HASH.hash:
            let errormsg = (BRIGHT_YELLOW & "TetoRC integrity hashes do not match!" & RESET & BRIGHT_RED & " Integrity error" & RESET)
            tmesg(0, errormsg)
            let fd = open(hashloc, O_WRONLY or O_CREAT, 0o644)
            discard write(fd, cstring(HASH.hash), len(HASH.hash))
            discard close(fd)
        else:
            let successmsg = (BRIGHT_GREEN & "TetoRC integrity verified successfully!" & RESET)
            tmesg(0, successmsg)
    else:
        stdout.write(BRIGHT_YELLOW & "Embedding TetoRC hash into filesystem... \n" & RESET)
        let fd = open(hashloc, O_WRONLY or O_CREAT, 0o644)
        discard write(fd, cstring(HASH.hash), len(HASH.hash))
        discard close(fd)
    

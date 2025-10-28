######## Main TetoRC Stage 1 file
import posix, os

## Include imports
import "../../include/universal", "../../include/dposix", "../../include/dcustom"

## Project imports
import "codegen", "msg"
import "../fs/vfs", "../fs/mount", "../fs/file"

## Project FFI imports
{.compile: "../init/init.c".}
{.compile: "../init/exec.c".}
{.compile: "../init/shutdown.c".}



#### Main function ####
#######################
proc mainfunc() =
      stdout.write(CLEAR)
      centerText(BOLD & "TetoRC Stage " & STAGE & " is loading ......" & RESET & "\n")
      if uname(addr u) == 0:
            stdout.write("\n", BRIGHT_WHITE, "TetoRC version ", RESET, BRIGHT_MAGENTA, TETVER, RESET, BRIGHT_WHITE, " starting up ", RESET, BOLD, BRIGHT_CYAN, cast[cstring](addr u.sysname[0]), RESET, BOLD," - ", RESET, BOLD, BRIGHT_RED, cast[cstring](addr u.release[0]), RESET, "\n \n")
      elif defined Linux:
            stdout.write("\n", "TetoRC version ", TETVER, " starting up Linux (unable to get utsname) \n \n")
      else:
            stdout.write("\n", "TetoRC version ", TETVER, " starting up (unable to get osname + utsname) \n \n")

      ## Mount most things and display vfsinfo     
      discard vfsinfo("/")
      discard mounter(PROC_SRC, PROC_PATH, PROC_FS, PROC_FS_MNT, cast[pointer](PROC_FS_OPT))
      discard mounter(SYS_SRC, SYS_PATH, SYS_FS, SYS_FS_MNT, cast[pointer](SYS_FS_OPT))
      #discard umounter(DEV_PATH)
      #discard mounter(DEV_SRC, DEV_PATH, DEV_FS, DEV_FS_MNT, cast[pointer](DEV_FS_OPT))
      discard mounter(RUN_SRC, RUN_PATH, RUN_FS, RUN_FS_MNT, cast[pointer](RUN_FS_OPT))
      discard mounter(TMP_SRC, TMP_PATH, TMP_FS, TMP_FS_MNT, cast[pointer](TMP_FS_OPT))
      for dir in TETODIRS:
            makedir(dir)
        

      stdout.write("\n \n")
      cmain()



#### Start of bootstrap ####
############################
stdout.write(BOLD, "###############################################################################", RESET, "\n \n \n")
mainfunc()



  
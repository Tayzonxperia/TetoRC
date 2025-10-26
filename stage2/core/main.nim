######## Main TetoRC file
import posix, os, tables

## Include imports
import "../../include/dposix", "../../include/dcustom"

## Project imports
import "codegen", "runtime", "../fs/mount", "msg", "emergency"

## Project FFI imports
{.compile: "../init/init.c".}
{.compile: "../init/login.c".}
{.compile: "../init/shutdown.c".}


#### Main function ####
#######################

proc mainfunc() =
      stdout.write(BOLD, "###############################################################################", RESET, "\n \n")
      if uname(addr u) == 0:
            stdout.write("\n", BRIGHT_WHITE, "       TetoRC version ",RESET, BRIGHT_MAGENTA, TETVER, RESET, BRIGHT_WHITE, " starting up ",RESET, BOLD, BRIGHT_CYAN, cast[cstring](addr u.sysname[0]), RESET, BOLD," - ", RESET, BOLD, BRIGHT_RED, cast[cstring](addr u.release[0]), RESET, "\n \n")
      elif defined Linux:
            stdout.write("\n", "TetoRC version ", TETVER, " starting up Linux (unable to get utsname) \n \n")
      else:
            stdout.write("\n", "TetoRC version ", TETVER, " starting up (unable to get osname + utsname) \n \n")
      
      for path, flags in mntflags:
           stdout.write("(DEBUG) ", BRIGHT_BLUE, path, RESET, BOLD, " --> ", RESET, BLUE, "0x", flags, RESET, "\n")

      

      ## Mount everything      
      discard mounter(PROC_SRC, PROC_PATH, PROC_FS, PROC_FS_MNT, cast[pointer](PROC_FS_OPT))
      discard mounter(SYS_SRC, SYS_PATH, SYS_FS, SYS_FS_MNT, cast[pointer](SYS_FS_OPT))
      discard mounter(RUN_SRC, RUN_PATH, RUN_FS, RUN_FS_MNT, cast[pointer](RUN_FS_OPT))
      discard mounter(TMP_SRC, TMP_PATH, TMP_FS, TMP_FS_MNT, cast[pointer](TMP_FS_OPT))
      discard mounter(KASANE_SRC, KASANE_PATH, KASANE_FS, KASANE_FS_MNT, cast[pointer](KASANE_FS_OPT))

      cmain()

#### Start of bootstrap ####
############################

stdout.write(BOLD, "TetoRC is loading ...", RESET, "\n")
mainfunc()



  
######## Main TetoRC file
import posix  
## Imports from stdlib/nimble

import "../include/dposix", "../include/dcustom"
import "codegen", "../ipc/cli.nim", "../settings/hardcode.nim", "../settings/runtime.nim", "../fs/mount", "msg"


#### Main function

proc mainfunc() =
      ## Banner and messages
      stdout.write(BOLD, "###############################################################################", RESET, "\n \n")
      if uname(addr u) == 0:
            stdout.write("\n", BRIGHT_WHITE, "       TetoRC version ",RESET, BRIGHT_MAGENTA, TETVER, RESET, BRIGHT_WHITE, " starting up ",RESET, BOLD, BRIGHT_CYAN, cast[cstring](addr u.sysname[0]), RESET, BOLD," - ", RESET, BOLD, BRIGHT_RED, cast[cstring](addr u.release[0]), RESET, "\n \n")
      elif defined Linux:
            stdout.write("\n", "TetoRC version ", TETVER, " starting up Linux (unable to get utsname) \n \n")
      else:
            stdout.write("\n", "TetoRC version ", TETVER, " starting up (unable to get osname + utsname) \n \n")

      ## Mount everything      
      discard mounter(PROC_SRC, PROC_PATH, PROC_FS, proc_flags, cast[pointer](proc_options))
      discard mounter(SYS_SRC, SYS_PATH, SYS_FS, sys_flags, cast[pointer](sys_options))
      discard mounter(RUN_SRC, RUN_PATH, RUN_FS, run_flags, cast[pointer](run_options))
      discard mounter(TMP_SRC, TMP_PATH, TMP_FS, tmp_flags, cast[pointer](tmp_options))
      discard mounter(KASANE_SRC, KASANE_PATH, KASANE_FS, kasane_flags, cast[pointer](kasane_options))

      cinit()

#### Start of bootstrap
#######################

when isMainModule:
  if getpid() != 1:
      stdout.write(BOLD, "TetoRC triggered! Choose mode: \n ---| CLI \n ---| Exit \n", RESET)
      let tetomode = stdin.readline
      case tetomode:
      of "CLI":
            tetcli()
      of "EXIT":
            stdout.write(BOLD, "TetoRC is exiting as per user input... \n", RESET)
            quit(0)
      else:
            stdout.write(BOLD, "TetoRC is exiting - Reason: Unknown command \n", RESET)
            quit(1)
else:
      stdout.write(BOLD, "TetoRC is loading ...", RESET, "\n")
      mainfunc()


  
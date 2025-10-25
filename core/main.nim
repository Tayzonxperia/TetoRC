######## Main TetoRC file
import posix, tables
## Imports from stdlib/nimble

import "../include/dposix", "../include/dcustom"
import "codegen", "runtime", "../fs/mount", "msg", "../ipc/cli"


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
      when defined(debug):
            for path, flags in mntflags:
                  stdout.write(BRIGHT_BLUE, path, RESET, BOLD, " --> ", RESET, BLUE, "0x", flags, RESET, "\n")


      ## Mount everything      
      discard mounter(PROC_SRC, PROC_PATH, PROC_FS, PROC_FS_MNT, cast[pointer](PROC_FS_OPT))
      discard mounter(SYS_SRC, SYS_PATH, SYS_FS, SYS_FS_MNT, cast[pointer](SYS_FS_OPT))
      discard mounter(RUN_SRC, RUN_PATH, RUN_FS, RUN_FS_MNT, cast[pointer](RUN_FS_OPT))
      discard mounter(TMP_SRC, TMP_PATH, TMP_FS, TMP_FS_MNT, cast[pointer](TMP_FS_OPT))
      discard mounter(KASANE_SRC, KASANE_PATH, KASANE_FS, KASANE_FS_MNT, cast[pointer](KASANE_FS_OPT))

      discard sleep(1000)

#### Start of bootstrap
#######################

when isMainModule:
  if getpid() != 1:
      when defined(debug):
            stdout.write(BRIGHT_YELLOW, "Warning: ", RESET, BOLD, "CLI mode is disabled in debug builds of TetoRC \n")
            stdout.write(BOLD, "TetoRC triggered! Showing debug attrs... \n", RESET)
            stdout.write(BOLD, "INI: ", cfg, "\nCFG: ", mountcfg, RESET, "\n \n")
            for path, flags in mntflags:
                  stdout.write(BRIGHT_BLUE, path, RESET, BOLD, " --> ", RESET, BLUE, "0x", flags, RESET, "\n")
            stdout.write("\n", BOLD, "Mounting info: (SRC, PATH, FS, FS_MNT, FS_OPT) \n")
            stdout.write("\n PROC SRC: ", PROC_SRC, "\n SYS_SRC: ", SYS_SRC, "\n RUN_SRC: ", RUN_SRC, "\n TMP_SRC: ", TMP_SRC, "\n KASANE_SRC: ", KASANE_SRC)
            stdout.write("\n PROC_PATH: ", PROC_PATH, "\n SYS_PATH: " , SYS_PATH, "\n RUN_PATH: ", RUN_PATH, "\n TMP_PATH: ", TMP_PATH, "\n KASANE_PATH: ", KASANE_PATH)
            stdout.write("\n PROC_FS: ", PROC_FS, "\n SYS_FS: ", SYS_FS, "\n RUN_FS: ", RUN_FS, "\n TMP_FS: ", TMP_FS, "\n KASANE_FS: ", KASANE_FS)
            stdout.write("\n PROC_FS_MNT: ", PROC_FS_MNT, "\n SYS_FS_MNT: ", SYS_FS_MNT, "\n RUN_FS_MNT: ", RUN_FS_MNT, "\n TMP_FS_MNT: ", TMP_FS_MNT, "\n KASANE_FS_MNT: [T]", KASANE_FS_MNT)
            stdout.write("\n PROC_FS_OPT: ", PROC_FS_OPT, "\n SYS_FS_OPT: ", SYS_FS_OPT, "\n RUN_FS_OPT: ", RUN_FS_OPT, "\n TMP_FS_OPT: ", TMP_FS_OPT, "\n KASANE_FS_OPT: ", KASANE_FS_OPT)
      else:
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
      try:
            stdout.write(BOLD, "TetoRC is loading ...", RESET, "\n")
            mainfunc()
            discard sleep(100)
      except OSError as e:
            stdout.write("OSError: ", e.msg, "\n")
      except Exception as e:
            stdout.write("Unexpected error: ", e.msg, "\n")



  
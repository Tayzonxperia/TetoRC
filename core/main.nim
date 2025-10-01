import posix

import "../include/dposix", init, "../settings/hardcode.nim", "../settings/runtime.nim", "../fs/mount", msg

when defined(build_extra): 
      import "../utils/shell"


#### Main function
##################

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
      discard swaper(SWAP_1, 0)

      ## PID 1 init responibilites
      initsignals()
      while true:
            if REC_SIGCHLD:
                  var status: cint
                  while waitpid(-1, status.addr, posix.WNOHANG) > 0:
                        stdout.write("[ SIG ] Child reaped")
                        REC_SIGCHLD = false
            if REC_SIGTERM:
                  posix.sync()
                  const msg = "SYSTEM GOING DOWN NOW!"
                  tmesg(0.cint, msg)
                  REC_SIGTERM = false
                  discard umount(KASANE_PATH)
                  discard umount(TMP_PATH)
                  discard umount(RUN_PATH)
                  discard swapoff(SWAP_1)
                  reboot(LINUX_REBOOT_CMD_POWER_OFF)
            
      when defined(build_extra):
            tetshell()

      stdout.write("\n")
      var argv: seq[cstring] = @["/bin/bash.cstring", nil] 
      var envp: seq[cstring] = @["TERM=linux".cstring, "PATH=/usr/sbin:/usr/bin:/sbin:/bin".cstring, "EINFO_COLOR=1".cstring, nil]
      discard execve("/bin/bash".cstring, cast[ptr cstringArray](argv[0].addr), cast[ptr cstringArray](envp[0].addr))

#### Start of bootstrap
#######################

mainfunc()


  
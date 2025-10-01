import posix, os # Imports

import "../settings/hardcode" 


## tmesg

proc tmesg*[T](ret: T, successmsg: string, errormsg: string = "") {.inline.} = 
      when T is int:
            ret = ret.cint
      elif T is cint:
            discard ret
      if ret == 0:
            stdout.write("[ ", BRIGHT_GREEN, "OK", RESET, " ] ", BOLD, successmsg, RESET, "\n")
      else:
            stderr.write("[ ", BRIGHT_RED, "ERR", RESET, " ] ", BOLD, errormsg, RESET, "[Error code:", BOLD, ret, RESET, "] \n")


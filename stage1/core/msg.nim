######## Message and console functions
import posix, strutils

## Project imports
import "codegen" 


#### Function that writes to display
proc tmesg*[T](ret: T, successmsg: string, errormsg: string = "") {.inline.} = 
      var varret: cint
      when T is int:
            varret = ret.cint
      elif T is cint:
            varret = ret
      else:
            varret = 0
      if varret == 0:
            stdout.write("[ ", BRIGHT_GREEN, "OK", RESET, " ] ", BOLD, successmsg, RESET, "\n")
      else:
            stderr.write("[ ", BRIGHT_RED, "ERR", RESET, " ] ", BOLD, errormsg, RESET, "[Error code:", BOLD, ret, RESET, "] \n")


proc centerText*(text: string) =
  let width = 80 # std tty width
  let textLen = text.len
  let padding = max(0, (width - textLen) div 2)
  echo repeat(' ', padding) & text
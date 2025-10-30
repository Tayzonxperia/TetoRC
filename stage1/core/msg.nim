######## Message and console functions
import posix, strutils, osproc, os

## Project imports
import "../../include/universal"


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

#### Centers text
proc centerText*(text: string) =
  let width = 80 # std tty width
  let textLen = text.len
  let padding = max(0, (width - textLen) div 2)
  echo repeat(' ', padding) & text


#### Shows splash
proc showsplash*(text: string) =
      let cmd = ("python3 /kasane/tetorc/modules/tascii.py -2 -l " & text)
      discard execcmd(cmd)
      
## JP fontfinder
proc hasJPFile*(): bool =
      for path in JPFONTPATHS:
            if fileExists(path):
                  return true
            else:
                  return false
      return false

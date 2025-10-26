import posix, os, strutils

import "../include/dposix"
import "../settings/hardcode", "../settings/runtime", "socket", "../core/codegen"


## TetoRC CLI interface

proc tetcli*(): cstring =
    stdout.write(BOLD, "TetoRC activated in CLI mode >>>", RESET, "\n")
    stdout.write("[ ", BRIGHT_MAGENTA, "TETCLI", RESET, " ]", MAGENTA, " ==> ", RESET)
    let tetcmd = stdin.readline
    


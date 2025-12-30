import posix, strformat, macros

import "codegen"


## START ##
###########


type CTlevel = enum
    ctInfo, ctWarn, ctError, ctTrace


proc logCompile(lvl: CTlevel, text: string) {.compileTime.} =
    if lvl == ctInfo:
        echo(fmt"Nim:[{BRIGHT_WHITE}{lvl}{RESET}] ==> {BRIGHT_WHITE}{text}{RESET}" & "\n")
    elif lvl == ctWarn:
        echo(fmt"Nim:[{BRIGHT_YELLOW}{lvl}{RESET}] ==> {BRIGHT_YELLOW}{text}{RESET}" & "\n")
    elif lvl == ctError:
        echo(fmt"Nim:[{BRIGHT_RED}{lvl}{RESET}] ==> {BRIGHT_RED}{text}{RESET}" & "\n")
    elif lvl == ctTrace:
        echo(fmt"Nim:[{BRIGHT_CYAN}{lvl}{RESET}] ==> {BRIGHT_CYAN}{text}{RESET}" & "\n")


template ctInfo*(text: string) =
    logCompile(ctInfo, text)

template ctWarn*(text: string) =
    logCompile(ctWarn, text)

template ctError*(text: string) =
    logCompile(ctError, text)

template ctTrace*(text: string) =
    when defined debug:
        logCompile(ctTrace, text)
    else:
        discard

macro ctASTdmp*(text: static[string], ast: untyped): untyped =
    echo("\nAST Dump: " & text & "\n" & ast.treeRepr & "\n")
    return ast
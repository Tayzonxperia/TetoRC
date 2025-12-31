#!/usr/bin/env nim
import posix, strformat

import "src/data/constants"


let cwd = getCurrentDir()
const PROGRAM = "TetoRC"
const VERSION = "1.4.1-alpha1"
let BUILD_DIR = cwd & "/Build"

author = "Wakana Kisarazu"
packagename = "tetorc"
description = """TetoRC — A Fast, Modern, Nim-Based Init System
                
              TetoRC is a lightning-fast, stable, and modular 
              init system written primarily in Nim — a powerful 
              high-level language that compiles directly to C"""
version = VERSION 
backend = "C"
license = "GPL 2"

mode = ScriptMode.Verbose


## START ##
###########

const 
  CFLAGS: string = "-march=native -mtune=native -O3 " &
                  "-flto -pipe -fmerge-all-constants " &
                  "-fno-strict-aliasing -fno-ident -fno-rtti " &
                  "-fdata-sections -ffunction-sections"

  LDFLAGS: string = "-Wl,-O3,-flto,-Tbuild.ld,--build-id=none"

  DEFINES: string = "--threads:on --opt:speed " &
                    "--debuginfo:off -d:strip " &
                    "-d:lto --maxLoopIterationsVM:9999999999"


type DependencyType = enum 
  Required, Optional

type Dependencies = object
  dependency: string
  depHas: bool
  depType:DependencyType

const DEPS =
  [
  "nim",
  "gcc",
  "ld",
  "ar",
  "zstd",
  "python3",
  "upx"
  ]
  

type GenLevel = enum
    GenDebg, GenInfo, GenOkay, GenWarn, GenFail

proc logGen(lvl: GenLevel, text: string) =
    if lvl == GenDebg:
        echo(fmt"Nim:[{BOLD & CYAN}{lvl}{RESET}] ==> {BRIGHT_CYAN}{text}{RESET}" & "\n")
    elif lvl == GenInfo:
        echo(fmt"Nim:[{BOLD & WHITE}{lvl}{RESET}] ==> {BRIGHT_WHITE}{text}{RESET}" & "\n")
    elif lvl == GenOkay:
        echo(fmt"Nim:[{BOLD & GREEN}{lvl}{RESET}] ==> {BRIGHT_GREEN}{text}{RESET}" & "\n")
    elif lvl == GenWarn:
        echo(fmt"Nim:[{BOLD & YELLOW}{lvl}{RESET}] ==> {BRIGHT_YELLOW}{text}{RESET}" & "\n")
    elif lvl == GenFail:
        echo(fmt"Nim:[{BOLD & RED}{lvl}{RESET}] ==> {BRIGHT_RED}{text}{RESET}" & "\n")


template logDebg*(text: string) =
    when defined(debug):
        logGen(GenDebg, text)
    else:
        discard

template logInfo*(text: string) =
    logGen(GenInfo, text)

template logOkay*(text: string) =
    logGen(GenOkay, text)

template logWarn*(text: string) =
    logGen(GenWarn, text)

template logFail*(text: string) =
    logGen(GenFail, text)

exec "clear"; logInfo("Checking host system...")

when not defined(Linux) and not defined(amd64) or defined(i368):
  logWarn("""TetoRC system init is not expected to work on or even compile for 
          any other ABIs than Linux x86_64 --- --- Proceed at your own risk!""")
  discard posix.sleep(2)


logInfo("Preparing to compile " & BOLD & MAGENTA & PROGRAM & RESET & " " & CYAN & VERSION & RESET)

for dep in DEPS:
  var depGraph = Dependencies(
    dependency: dep,              
    depHas: false,                
    depType: Required)

  logInfo("Checking for dependency: " & BOLD & dep & RESET)
  if gorgeEx("command -v " &  dep).exitCode != 0:
    depGraph.depHas = false

    if dep == "python3" or dep == "upx":
      depGraph.depType = Optional
      logWarn("Dependency: " & BOLD & dep & RESET & " not found! Disabling " &
              BOLD & dep & RESET & " functionallity")
    else:
        depGraph.depType = Required
        logFail("Dependency: " & BOLD & dep & RESET & " not found! Cannot " &
        "continue, aborting..."); quit("Dependency not found", 1)
  else:
    depGraph.depHas = true
logOkay("Dependencies verified!")


logInfo("Starting compilation of " & BOLD & MAGENTA & PROGRAM & RESET & " " & CYAN & VERSION & 
        RESET & " with Nim: " & NimVersion & " at " & CompileTime & " (" & CompileDate & ")")

###############################################################################################

proc compileLibaries(srcfile, filename, extradefines: string) =
  if extradefines == "":
    discard

  let cmd = "nim c -f --out:\"" & BUILD_DIR & "/lib/" & filename & "\"" &
  " " & DEFINES & " -d:shared -d:" & extradefines & " --app:lib --passC:\"" & CFLAGS & "\"" & " --passL:\"" &
  LDFLAGS & "\" " & srcfile

  try:
    logInfo("Compiling " & filename & " libary...")
    exec cmd
    logOkay("Compilation completed successfully"); echo("\n")
  except CatchableError as e:
    logFail("Error: Compilation of libary " & filename & " failed!\nOutput: " & e.msg); echo("\n")


proc compileBinaries(srcfile, filename, extradefines: string) =
  if extradefines == "":
    discard

  let cmd = "nim c -f --out:\"" & BUILD_DIR & "/bin/" & filename & "\"" &
  " " & DEFINES & " -d:shared -d:" & extradefines & " --app:console --passC:\"" & CFLAGS & "\"" &
  " --passL:\"" & LDFLAGS & "\" " & srcfile

  try:
    logInfo("Compiling " & filename & " binary...")
    exec cmd
    logOkay("Compilation completed successfully"); echo("\n")
  except CatchableError as e:
    logFail("Error: Compilation of binary " & filename & " failed!\nOutput: " & e.msg); echo("\n")


## Actually make the fuckin bastards, hell most of
## this prep was for nothin but oh well :3

compileBinaries("src/tetorc_loader/main.nim", "tetorc-ldr.bin", "tetorc-ldr")
#compileBinaries("src/tetorc_service.nim", "tetorc-svc.bin", "tetorc-svc")
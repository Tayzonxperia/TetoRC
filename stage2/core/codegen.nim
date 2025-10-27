######## Compiler code generation file
import posix, os, strutils

## Include imports
import "../../include/universal", "../../include/dposix"



#### Compiler codegenerator ####
################################

## Stage define
const STAGE* = "2"

static: 
    echo(BOLD & "Compiling TetoRC (Stage " & $STAGE & ") at " & RESET & BRIGHT_BLUE & CompileTime & " ~ " & CompileDate & RESET)
    if defined(danger):
        echo(BRIGHT_YELLOW & "---# " & RESET & YELLOW & "Warning: " & RESET & "Danger mode enabled! Runtime checking off!")
    if defined(gcoff):
        echo(BRIGHT_RED & "---! " & RESET & RED & "Warning: " & RESET & "Garbage collecter disabled! Segfaults possible!")

    echo(BOLD & "Determining if we are linking staticlly or shared..." & RESET)
    if defined(static):
        echo(BRIGHT_GREEN & "---> " & RESET & "Link state: Static")
    elif defined(shared):
        echo(BRIGHT_GREEN & "---> " & RESET & "Link state: Shared")
    
    echo(BOLD & "Computing compiler code..." & RESET)

    echo(BRIGHT_GREEN & "---> " & RESET & "Computing mount tables...")
    

#### Computed constants and lets ####
#####################################

const TETVER*:string = static: readfile("../version.txt").strip()
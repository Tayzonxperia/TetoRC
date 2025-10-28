######## Compiler code generation file
import posix, os, strutils

## Include imports
import "../../include/universal", "../../include/dposix"



#### Compiler codegenerator ####
################################

## Stage define
const STAGE* = "1"

static: 
    echo(BOLD & "Compiling TetoRC (Stage " & $STAGE & ") at " & RESET & BRIGHT_BLUE & CompileTime & " ~ " & CompileDate & RESET & "\n")

    echo(BOLD & "Checking safety measures...")
    if defined(danger):
        echo(BRIGHT_YELLOW & "---# " & RESET & YELLOW & "Warning: " & RESET & "Danger mode enabled! Runtime checking off!")
    if defined(gcoff):
        echo(BRIGHT_RED & "---! " & RESET & RED & "Warning: " & RESET & "Garbage collecter disabled! Segfaults possible!")
    echo("\n")
    
    echo(BOLD & "Determining if we are linking staticlly or shared..." & RESET) 
    if defined(static):
        echo(BRIGHT_GREEN & "---> " & RESET & "Link state: Static \n")
    elif defined(shared):
        echo(BRIGHT_GREEN & "---> " & RESET & "Link state: Shared \n")
    
    echo(BOLD & "Checking compilation preset..." & RESET)
    if defined(default):
        echo(BRIGHT_GREEN & "---> " & RESET & "Preset: Default \n")
    elif defined(debug):
        echo(BRIGHT_YELLOW & "---# " & RESET & "Preset: Debug \n")
    elif defined(optimized):
        echo(BRIGHT_CYAN & "---> " & RESET & "Preset: Optimized \n")
    elif defined(tiny):
        echo(BRIGHT_BLUE & "---> " & RESET & "Preset: Tiny \n")


    echo(BOLD & "Computing compiler code..." & RESET)
 
    echo(BRIGHT_GREEN & "---> " & RESET & "Computing mount tables... \n")
    

#### Computed constants and lets ####
#####################################

const TETVER*:string = static: readfile("../version.txt").strip()
######## Compiler code generation file
import posix, os, strutils, tables

## Include imports
import "../../include/universal", "../../include/dposix"



#### Compiler codegenerator ####
################################

## Stage define
const STAGE* = "1"

static: 
    echo(BOLD & "Compiling TetoRC (Stage " & $STAGE & ") at " & RESET & BRIGHT_BLUE & CompileTime & " ~ " & CompileDate & RESET & " with " & BRIGHT_MAGENTA & "Nim " & Nimversion & "\n" & RESET)

    echo(BOLD & "Checking safety measures...")
    when defined(danger):
        echo(BRIGHT_YELLOW & "---# " & RESET & YELLOW & "Warning: " & RESET & "Danger mode enabled! Runtime checking off!")
    when defined(gcoff):
        echo(BRIGHT_RED & "---! " & RESET & RED & "Warning: " & RESET & "Garbage collecter disabled! Segfaults possible!")
    when defined(panic):
        echo(BRIGHT_RED & "---! " & RESET & RED & "Warning: " & RESET & "Panics enabled! TetoRC will fail on most errors! Not recomended!")

    
    echo("\n" & BOLD & "Determining if we are linking staticlly or shared..." & RESET) 
    when defined(static):
        echo(BRIGHT_WHITE & "---> " & RESET & "Link state: Static \n")
    elif defined(shared):
        echo(BRIGHT_WHITE & "---> " & RESET & "Link state: Shared \n")
    
    echo(BOLD & "Checking compilation preset..." & RESET)
    when defined(default):
        echo(BRIGHT_WHITE & "---> " & RESET & "Preset: Default \n")
    elif defined(debug):
        echo(BRIGHT_YELLOW & "---# " & RESET & "Preset: Debug \n")
    elif defined(optimized):
        echo(BRIGHT_WHITE & "---> " & RESET & "Preset: Optimized \n")
    elif defined(tiny):
        echo(BRIGHT_WHITE & "---> " & RESET & "Preset: Tiny \n")

    
    when defined(optimized) or defined(tiny):
        const COMPILETIMESCRIPT = "bash ../../Build/codegen/sysinfo.sh"        
        proc buildSYSspecification(raw: string): SYSspec {.compileTime.} =
            var sysinfo = initTable[string, string]()
            for line in raw.splitLines():
                if line.contains("="):
                    let parts = line.split("=", maxsplit = 1)
                    sysinfo[parts[0].strip()] = parts[1].strip()

                result.os        = sysinfo.getOrDefault("os", "")
                result.cc        = sysinfo.getOrDefault("cc", "")
                result.linker     = sysinfo.getOrDefault("linker", "")
                result.assembler  = sysinfo.getOrDefault("assembler", "")
                result.hostname   = sysinfo.getOrDefault("hostname", "")
                result.kernName   = sysinfo.getOrDefault("kern_name", "")
                result.kernRel    = sysinfo.getOrDefault("kern_rel", "")
                result.kernVer    = sysinfo.getOrDefault("kern_ver", "")
                result.cpuArch    = sysinfo.getOrDefault("cpu_arch", "")
                result.cpuVendor  = sysinfo.getOrDefault("cpu_vendor", "")
                result.cpuModel   = sysinfo.getOrDefault("cpu_model", "")
                result.cpuCores   = sysinfo.getOrDefault("cpu_cores", "")
                result.cpuFlags   = sysinfo.getOrDefault("cpu_flags", "")
                result.cpuL1d     = sysinfo.getOrDefault("cpu_cache_l1d", "")
                result.cpuL1dSize = sysinfo.getOrDefault("cpu_cache_l1d_SIZE", "")
                result.cpuL1dX    = sysinfo.getOrDefault("cpu_cache_l1d_X", "")
                result.cpuL1i     = sysinfo.getOrDefault("cpu_cache_l1i", "")
                result.cpuL1iSize = sysinfo.getOrDefault("cpu_cache_l1i_SIZE", "")
                result.cpuL1iX    = sysinfo.getOrDefault("cpu_cache_l1i_X", "")
                result.cpuL2      = sysinfo.getOrDefault("cpu_cache_l2", "")
                result.cpuL2Size  = sysinfo.getOrDefault("cpu_cache_l2_SIZE", "")
                result.cpuL2X     = sysinfo.getOrDefault("cpu_cache_l2_X", "")
                result.cpuL3      = sysinfo.getOrDefault("cpu_cache_l3", "")
                result.cpuL3Size  = sysinfo.getOrDefault("cpu_cache_l3_SIZE", "")
                result.cpuL3X     = sysinfo.getOrDefault("cpu_cache_l3_X", "")
                result.memTotal   = sysinfo.getOrDefault("mem_total", "")
        
        const SYS = buildSYSspecification(staticexec(COMPILETIMESCRIPT))

        echo(BOLD & "Determining full system specifications..." & RESET)
        echo(BRIGHT_WHITE & "---> " & RESET & "Host: " & SYS.hostname)  
        echo(BRIGHT_WHITE & "---> " & RESET & "C compiler: " & SYS.cc) 
        echo(BRIGHT_WHITE & "---> " & RESET & "Linker: " & SYS.linker) 
        echo(BRIGHT_WHITE & "---> " & RESET & "Assembler: " & SYS.assembler) 
        when defined(Linux):
            echo(BRIGHT_WHITE & "---> " & RESET & "OS: " & "Linux")  
        else:
            echo(BRIGHT_WHITE & "---> " & RESET & "OS: " & SYS.os)
        echo(BRIGHT_WHITE & "---> " & RESET & "Kernel: " & SYS.kernName & " " & SYS.kernRel)
        echo(BRIGHT_WHITE & "---> " & RESET & "Kernel version info: " & SYS.kernVer)
            
        echo(BRIGHT_CYAN & "Determining CPU specifications..." & RESET)
        echo(BRIGHT_GREEN & "---> " & RESET & "Architecture: " & SYS.cpuArch)
        when defined(debug):
            for flag in splitwhitespace(SYS.cpuFLags):
                echo(BRIGHT_CYAN & "---> " & RESET & "CPU has flag: " & flag)
        echo(BRIGHT_GREEN & "---> " & RESET & "Cores: " & SYS.cpuCores)
        echo(BRIGHT_GREEN & "---> " & RESET & "L1d Cache: " & SYS.cpuL1d & SYS.cpuL1dSize & " " & SYS.cpuL1dX) 
        echo(BRIGHT_GREEN & "---> " & RESET & "L1i Cache: " & SYS.cpuL1i & SYS.cpuL1iSize & " " & SYS.cpuL1iX)
        echo(BRIGHT_GREEN & "---> " & RESET & "L2 Cache: " & SYS.cpuL2 & SYS.cpuL2Size & " " & SYS.cpuL2X)
        echo(BRIGHT_GREEN & "---> " & RESET & "L3 Cache: " & SYS.cpuL3 & SYS.cpuL3Size & " " & SYS.cpuL3X)
        echo(BRIGHT_CYAN & "Determining hardware specifications..." & RESET)
        echo(BRIGHT_GREEN & "---> " & RESET & "RAM: " & SYS.memTotal)    

    echo(BOLD & " \n Compiling..." & RESET)
      
    

#### Computed constants and lets ####
#####################################

const TETVER*:string = static: readfile("../version.txt").strip
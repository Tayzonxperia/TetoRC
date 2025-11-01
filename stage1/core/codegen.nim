######## TetoRC Stage 1 CCG file
import posix, os, strutils, tables

## Include imports
import "../../include/universal", "../../include/dposix"



#### Compiler codegenerator ####
################################

## Stage define
const STAGE* = "1"

## Version
const TETVER*:string = static: readfile("../version.txt").strip

const sysinfoSCRIPT = "bash ../../Build/Codegen/sysinfo.sh"   
const hashSCRIPT = "bash ../../Build/Codegen/hash.sh"

static:
    echo(BOLD & "Compiling TetoRC (Stage " & $STAGE & ") at " & RESET & BRIGHT_BLUE & CompileTime & " ~ " & CompileDate & RESET & " with " & BRIGHT_MAGENTA & "Nim " & Nimversion & "\n" & RESET)
   
    echo(BOLD & BRIGHT_MAGENTA & "Calculating compile-time hash..." & RESET)
    
proc buildHASHspecification(raw: string): HASHspec {.compileTime.} =
    var hashinfo = initTable[string, string]()
    for line in raw.splitLines():
        if line.contains("="):
            let parts = line.split("=", maxsplit = 1)
            hashinfo[parts[0].strip()] = parts[1].strip()

            result.hash        = hashinfo.getOrDefault("hash", "")
            result.hasher      = hashinfo.getOrDefault("hasher", "")

const HASH* = buildHASHspecification(staticexec(hashSCRIPT))

static:
    if HASH.hash == nil:
        echo(BRIGHT_RED & "---! " & RESET & RED & "Error: " & RESET & "Could not calculate hash! Aborting")
        quit(0)
    else:
        echo(BRIGHT_MAGENTA & "===> " & RESET & "Hash: " & BOLD & HASH.hash & RESET & " (" & HASH.hasher & ")")

    echo("\n" & BOLD & "Checking safety measures..." & RESET)
    when defined(danger):
        echo(BRIGHT_YELLOW & "---# " & RESET & YELLOW & "Warning: " & RESET & "Danger mode enabled! Runtime checking off!")
    when defined(gcoff):
        echo(BRIGHT_RED & "---! " & RESET & RED & "Warning: " & RESET & "Garbage collecter disabled! Segfaults possible!")
    when defined(panic):
        echo(BRIGHT_RED & "---! " & RESET & RED & "Warning: " & RESET & "Panics enabled! TetoRC will fail on most errors! Not recomended for non-developers!")
    when not defined(danger) and not defined(gcoff) and not defined(panic):
        echo(BRIGHT_GREEN & "---> " & RESET & GREEN & "Safety measures enabled!" & RESET)
    
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
   
proc buildSYSspecification(raw: string): SYSspec {.compileTime.} =
    var sysinfo = initTable[string, string]()
    for line in raw.splitLines():
        if line.contains("="):
            let parts = line.split("=", maxsplit = 1)
            sysinfo[parts[0].strip()] = parts[1].strip()

            result.os                    = sysinfo.getOrDefault("os", "")
            result.cc                    = sysinfo.getOrDefault("cc", "")
            result.linker                = sysinfo.getOrDefault("linker", "")
            result.assembler             = sysinfo.getOrDefault("assembler", "")
            result.hostname              = sysinfo.getOrDefault("hostname", "")
            result.kernName              = sysinfo.getOrDefault("kern_name", "")
            result.kernRel               = sysinfo.getOrDefault("kern_rel", "")
            result.kernVer               = sysinfo.getOrDefault("kern_ver", "")
            result.hasNvidia             = sysinfo.getOrDefault("has_nvidia", "")
            result.nvidiaModinfo         = sysinfo.getOrDefault("nvidia_modinfo", "")
            result.cpuArch               = sysinfo.getOrDefault("cpu_arch", "")
            result.cpuVendor             = sysinfo.getOrDefault("cpu_vendor", "")
            result.cpuModel              = sysinfo.getOrDefault("cpu_model", "")
            result.cpuCores              = sysinfo.getOrDefault("cpu_cores", "")
            result.cpuFlags              = sysinfo.getOrDefault("cpu_flags", "")
            result.cpuL1d                = sysinfo.getOrDefault("cpu_cache_l1d", "")
            result.cpuL1dSize            = sysinfo.getOrDefault("cpu_cache_l1d_SIZE", "")
            result.cpuL1dX               = sysinfo.getOrDefault("cpu_cache_l1d_X", "")
            result.cpuL1i                = sysinfo.getOrDefault("cpu_cache_l1i", "")
            result.cpuL1iSize            = sysinfo.getOrDefault("cpu_cache_l1i_SIZE", "")
            result.cpuL1iX               = sysinfo.getOrDefault("cpu_cache_l1i_X", "")
            result.cpuL2                 = sysinfo.getOrDefault("cpu_cache_l2", "")
            result.cpuL2Size             = sysinfo.getOrDefault("cpu_cache_l2_SIZE", "")
            result.cpuL2X                = sysinfo.getOrDefault("cpu_cache_l2_X", "")
            result.cpuL3                 = sysinfo.getOrDefault("cpu_cache_l3", "")
            result.cpuL3Size             = sysinfo.getOrDefault("cpu_cache_l3_SIZE", "")
            result.cpuL3X                = sysinfo.getOrDefault("cpu_cache_l3_X", "")
            result.memTotal              = sysinfo.getOrDefault("mem_total", "")
            result.boardName             = sysinfo.getOrDefault("board_name", "")
            result.boardManufacturer     = sysinfo.getOrDefault("board_manufacturer", "")
            result.productName           = sysinfo.getOrDefault("product_name", "")
            result.biosVendor            = sysinfo.getOrDefault("bios_vendor", "")
            result.biosVersion           = sysinfo.getOrDefault("bios_version", "")
            result.biosType              = sysinfo.getOrDefault("bios_type", "")
            result.rootDisk              = sysinfo.getOrDefault("root_disk", "")
            result.rootDisksize          = sysinfo.getOrDefault("root_disksize", "")
            result.rootDiskpart          = sysinfo.getOrDefault("root_diskpart", "")
            result.rootDiskuuid          = sysinfo.getOrDefault("root_diskuuid", "") 
            result.rootDiskfs            = sysinfo.getOrDefault("root_diskfs", "") 

const SYS* = when defined(optimized) or defined(tiny) and defined(Linux) or defined(Unix): buildSYSspecification(staticexec(sysinfoSCRIPT)) 

static:
        echo(BOLD & "Determining full system specifications..." & RESET)
        echo(BRIGHT_WHITE & "---> " & RESET & "Host: " & SYS.hostname)  
        echo(BRIGHT_WHITE & "---> " & RESET & "C compiler: " & SYS.cc) 
        echo(BRIGHT_WHITE & "---> " & RESET & "Linker: " & SYS.linker) 
        echo(BRIGHT_WHITE & "---> " & RESET & "Assembler: " & SYS.assembler) 
        when defined(Linux):
            echo(BRIGHT_WHITE & "---> " & RESET & "OS: " & "Linux")  
        elif defined(Unix):
            echo(BRIGHT_WHITE & "---> " & RESET & "OS: " & "Unix based")  
        else:
            echo(BRIGHT_WHITE & "---> " & RESET & "OS: " & SYS.os)
        echo(BRIGHT_WHITE & "---> " & RESET & "Kernel: " & SYS.kernName & " " & SYS.kernRel)
        echo(BRIGHT_WHITE & "---> " & RESET & "Kernel version info: " & SYS.kernVer)
        #echo(BRIGHT_WHITE& "---> " & RESET & "Module info: " &)
        if SYS.hasNvidia == "true":
            echo(BRIGHT_WHITE & "---> " & RESET & SYS.hostname & " has a Nvidia GPU")  
            when defined(debug):
                for module in splitwhitespace(SYS.nvidiaModinfo):
                    echo(BRIGHT_CYAN & "---> " & RESET & "Nvidia module found: " & module)  
        else:
            echo(BRIGHT_WHITE & "---> " & RESET & SYS.hostname & " does not have a Nvidia GPU")  
        echo(BRIGHT_CYAN & "Determining CPU specifications..." & RESET)
        echo(BRIGHT_GREEN & "---> " & RESET & "Architecture: " & SYS.cpuArch)
        when defined(debug):
            for flag in splitwhitespace(SYS.cpuFLags):
                echo(BRIGHT_CYAN & "---> " & RESET & "CPU has flag: " & flag)
        if SYS.cpuCores >= "2":
            echo(BRIGHT_GREEN & "---> " & RESET & "Cores: " & SYS.cpuCores)
        else:
            echo(BRIGHT_YELLOW & "---> " & RESET & "Cores: " & SYS.cpuCores)
        echo(BRIGHT_GREEN & "---> " & RESET & "L1d Cache: " & SYS.cpuL1d & SYS.cpuL1dSize & " " & SYS.cpuL1dX) 
        echo(BRIGHT_GREEN & "---> " & RESET & "L1i Cache: " & SYS.cpuL1i & SYS.cpuL1iSize & " " & SYS.cpuL1iX)
        echo(BRIGHT_GREEN & "---> " & RESET & "L2 Cache: " & SYS.cpuL2 & SYS.cpuL2Size & " " & SYS.cpuL2X)
        echo(BRIGHT_GREEN & "---> " & RESET & "L3 Cache: " & SYS.cpuL3 & SYS.cpuL3Size & " " & SYS.cpuL3X)
        echo(BRIGHT_CYAN & "Determining hardware specifications..." & RESET)
        echo(BRIGHT_GREEN & "---> " & RESET & "Motherboard: " & SYS.boardName & " (Manufacturer: " & SYS.boardManufacturer & ")")
        echo(BRIGHT_GREEN & "---> " & RESET & "Product name: " & SYS.productName)
        echo(BRIGHT_GREEN & "---> " & RESET & "BIOS Vendor: " & SYS.biosVendor & " (Version: " & SYS.biosVersion & ")")
        echo(BRIGHT_GREEN & "---> " & RESET & "BIOS Type: " & SYS.biosType)
        if SYS.rootDisksize >= "1.0T":
            echo(BRIGHT_GREEN & "---> " & RESET & "Root Disk: " & SYS.rootDisk & " (Size: " & SYS.rootDisksize & ")") 
            echo(BRIGHT_GREEN & "---> " & RESET & "Root Disk partition: " & SYS.rootDiskpart & " (" & SYS.rootDiskfs & ") (UUID: " & SYS.rootDiskuuid & ")") 

        else:
            echo(BRIGHT_YELLOW & "---> " & RESET & "Root Disk: " & SYS.rootDisk & " (Size: " & SYS.rootDisksize & ")")
            echo(BRIGHT_YELLOW & "---> " & RESET & "Root Disk partition: " & SYS.rootDiskpart & " (" & SYS.rootDiskfs & ") (UUID: " & SYS.rootDiskuuid & ")") 
        
        echo(BOLD & " \n Compiling..." & RESET)
      


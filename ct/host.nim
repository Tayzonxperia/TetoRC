import posix, strutils, tables

import "logger"


## START ##
###########


type HOSTspec* = object
    os*, cc*, linker*, assembler*, hostname*, kernName*, kernRel*, kernVer*: string
    hasNvidia*, nvidiaModinfo*: string
    cpuArch*, cpuVendor*, cpuModel*, cpuCores*, cpuFlags*, microcode*: string
    cpuL1d*, cpuL1dSize*, cpuL1dX*: string
    cpuL1i*, cpuL1iSize*, cpuL1iX*: string
    cpuL2*, cpuL2Size*, cpuL2X*: string
    cpuL3*, cpuL3Size*, cpuL3X*: string 
    boardName*, boardManufacturer*, productName*, biosVendor*, biosVersion*, biosType*: string
    memTotal*, rootDisk*, rootDisksize*, rootDiskpart*, rootDiskuuid*, rootDiskfs*: string

const SCRIPT = "bash ../scripts/sysinfo.sh"   

proc buildHOSTspecification(raw: string): HOSTspec {.compileTime.} =
    var sysinfo = initTable[string, string]()
    ctTrace("Building SYS")
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

const HOST* = when defined(Linux) or defined(Unix): buildHOSTspecification(staticexec(SCRIPT)) 
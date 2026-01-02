import posix, os, strutils, strformat

import "../ct/hash", "../ct/host"
import "../data/constants"
import "../util/output"

## START ##
###########

proc showHelp*() =
    let progname = paramStr(0)

    let how_to = fmt"Usage: {progname} [OPTIONS]" & "\n\n"


    when defined(daemon):
        let header_text = ("""
TetoRC Daemon - TetoRC PID1 Initsystem""" & "\n")

        let usage_text = (fmt"""
Options:
        --status (-s)           Show current TetoRC status (Active or inactive)
        --version (-v)          Show TetoRC version
        --buildinfo             Show what machine specifications and toolchain TetoRC was compiled with
        --help (-h)             Show this help message 
        --usage                 Alias of --help""")
    

        echo(BOLD & BRIGHT_WHITE & header_text & RESET)
        echo(how_to & usage_text)


    when defined(loader):
        let header_text = ("""
TetoRC Loader - TetoRC PID1 Bootstrapper""" & "\n")

        let usage_text = (fmt"""
Options:
        --emergency (-e)        Skip most mounts, ignore config and launch /bin/sh ASAP
        --version (-v)          Show TetoRC version
        --buildinfo             Show what machine specifications and toolchain TetoRC was compiled with
        --help (-h)             Show this help message 
        --usage                 Alias of --help""")

 
        echo(BOLD & BRIGHT_WHITE & header_text & RESET)
        echo(how_to & usage_text)
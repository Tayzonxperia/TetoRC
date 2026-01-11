import unittest, strutils, os
import "../../src/config/cmdline"

suite "cmdline":
    test "parseCmdline":
        let cmdline = """
BOOT_IMAGE=/boot/vmlinuz-linux root=UUID=deadbeef-0000-0000-0000-feebdaed rw tetorc.stage2=/kasane/tetorc-stage2 tetorc.exec=/bin/bash tetorc.fstab loglevel=6 zram.num_devices=2"""


        writeFile("/tmp/test", cmdline)
        if fileExists("/tmp/test"):
            let ret = parseProcCmdline("/tmp/test")
            echo(ret)
        else:
            quit(1)
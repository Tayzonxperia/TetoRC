import unittest2
import "../../src/utils/detectinitrd"

suite "detectinitrd":
    test "detectinitrd":
        let ret = inInitramfs()

        check ret == false

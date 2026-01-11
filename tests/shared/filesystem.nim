import unittest2, posix
import "../../src/shared/filesystem"

const NON_AMBIENT_MOUNTS = [
    "/mnt",
    "/kasane",
    "/lib"
]

const AMBIENT_MOUNTS = [
    "/",
    "/usr",
    "/etc",
    "/proc",
    "/sys",
    "/dev",
    "/run/initramfs",
    "/oldroot",
    "/newroot",
    "/run/nextroot"
]


suite "filesystem":
    test "checkFstab":
        let ret = checkFstab()
        check ret == false

    test "isAmbientMount":
        for mount in NON_AMBIENT_MOUNTS:
            let ret = isAmbientMount(mount)
            check ret == false

        for mount in AMBIENT_MOUNTS:
            let ret = isAmbientMount(mount)
            check ret == true

    test "parseFstab":
        let ret = parseFstab()
        for entry in ret:
            echo("Device: " & entry.device & " mounted at " & entry.mountpoint & " (" & entry.fstype & ") with " &
            entry.options & " | Dump/Pass: " & $entry.dump & "/" & $entry.pass)
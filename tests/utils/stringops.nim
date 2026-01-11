import unittest2, strutils
import "../../src/utils/stringops"

suite "stringops":
    const fstab1: string = "/dev/sda1 / ext4 defaults 0 1 \n" &
                            "UUID=deadbeef /home ext4 rw,noatime 0 2 \n" &
                            "tmpfs /tmp tmpfs nosuid,nodev 0 0 \n"

    const fstab2: string = "/dev/sda1 / ext4 defaults 0 \n" &
                            "/dev/sda1 / ext4 defaults zero one \n" &
                            "/dev/sda1 / ext4 defaults 0 1 extra \n" &
                            "/dev/sda1   /   ext4    defaults    0    1 \n"
    const fstab3 = [
        "fstab",
        "fstab=1",
        "fstab=o93",
        "fstab==",
        "fstab==maybe",
        "fstab-1"
    ]

    const ascii1: string = "normal ascii \n" &
                            "ümlaut \n" & 
                            "日本語 \n" &
                            "emoji 🚀🔥💀 \n" &
                            "mixed ascii 😈 and text \n" &
                            "\u0000 \n" &
                            "\u200b \n" &
                            "foo\u200bbar \n"

    const fstab_arr = [
        fstab1,
        fstab2
    ]

    const char_arr = [
        '0',
        '1',
        '2',
        '3',
        'a',
        'b',
        'c',
        'd',
        'A',
        'B',
        'C',
        'D'
    ]
    
    test "asciiIsDigit":
        for char in char_arr:
            let ret = asciiIsDigit(char)
           
            if char in ['0', '1', '2', '3']:
                check ret == true
            else:
                check ret == false

    test "extractFirstWord":
        for fstab in fstab_arr:
            let ret = extractFirstWord(fstab)

            if fstab.startsWith("/dev/sda1"):
                check ret == "/dev/sda1"
            elif fstab.startsWith("fstab"):
                check ret == "fstab"
            else:
                continue
    
    test "stripPrefix":
        for fstab in fstab3:
            let ret = stripPrefix(fstab, "fstab")
            check ret != "fstab"
import posix, os, strutils # Imports

import "../include/dposix", "../core/msg", "../core/init", "../settings/hardcode", "../settings/runtime" # Project imports


## Mountchecker

proc mountcheck*(path: cstring): mountcheckRESULT =
      if $path in failpath: 
            stderr.write("[ ", BRIGHT_YELLOW, "WARN", RESET, " ] ", BOLD, WHITE, path, RESET, BOLD, " cannot be checked", RESET, "\n")
            return MountNotCheckable
      else: 
            for line in readfile("/proc/mounts").splitlines():
                  let fields = line.splitwhitespace()
                  if fields.len >= 2 and fields[1] == $path:
                        return Mounted
            return NotMounted       
           

## Mounter

proc mounter*[T](source: T, target: T, fstype: T, flag: uint, data: pointer): cint {.inline.}  =
      var src: cstring
      var tgt: cstring
      var fs: cstring
      when T is string:
            src = cstring(source)
            tgt = cstring(target)
            fs = cstring(fstype)
      elif T is cstring:
            src = source
            tgt = target
            fs = fstype
      var success = false
      while not success:
            let ret = mount(src, tgt, fs, flag, data)
            let mountck = mountcheck(tgt)
            if ret == 0 and (mountck in {Mounted, MountNotCheckable}):
                  let successmsg = ("Mounted " & $src & " (" & $fs & ") at " & $tgt)
                  tmesg(ret, successmsg)
                  success = true
            elif ret == 0 and (mountck in {NotMounted, MountNotCheckable}):
                  let errormsg = ("Mounted " & $src & " (" & $fs & ") at " & $tgt & "\n[ CRITWARN ] Mount could not be checked, could not confirm mountpoint \n")
                  tmesg(ret, errormsg)
                  success = true
            else:
                  let errormsg = ("Failed to mount " & $src & " at " & $tgt & " (" & $fs & ")")
                  tmesg(ret, errormsg)
                  stderr.write("Attempt again? ", BOLD, "(Y/n)", RESET, "\n")
                  success = false
                  let INPUT = readLine(stdin)
                  if INPUT.tolowerascii() != "y":
                        break


## Umounter

proc umounter*[T](target: T): cint {.inline.}  =
      var tgt: cstring
      when T is string:
            src = cstring(source)
            tgt = cstring(target)
            fs = cstring(fstype)
      elif T is cstring:
            src = source
            tgt = target
            fs = fstype
      var success = false
      while not success:
            let ret = umount(tgt)
            let mountck = mountcheck(tgt)
            if ret == 0 and (mountck in {NotMounted}):
                  let successmsg = ("Unmounted " & $tgt)
                  tmesg(ret, successmsg)
                  success = true
            elif ret == 0 and (mountck in {NotMounted, MountNotCheckable}):
                  let errormsg = ("Unmounted " & $tgt & "\n[ CRITWARN ] Mount could not be checked, could not confirm mountpoint \n")
                  tmesg(ret, errormsg)
                  success = true
            else:
                  let errormsg = ("Failed to unmount " & $tgt)
                  tmesg(ret, errormsg)
                  stderr.write("Attempt again? ", BOLD, "(Y/n)", RESET, "\n")
                  success = false
                  let INPUT = readLine(stdin)
                  if INPUT.tolowerascii() != "y":
                        break


## Swaper

proc swaper*(path: cstring, flags: cint): cint =
      let ret1 = swapon(path, flags) 
      if ret1 == 0:
            let successmsg = ($path & " mounted as swap")
            tmesg(ret1, successmsg)
      else:
            let warnmsg = "Swapon failed!"
            tmesg(ret1, warnmsg)

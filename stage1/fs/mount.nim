######## TetoRC Stage 1 mounter file
import posix, strutils

## Include imports
import "../../include/universal", "../../include/dposix"

## Project imports
import "vfs"
import "../core/codegen", "../core/msg"



## Mountchecker
proc mountchecker[T](target: T): bool {.inline.} =
      var tgt: cstring
      when T is string:
            tgt = cstring(target)
      elif T is cstring:
            tgt = target
      if tgt != PROC_PATH:
            let MNTS = readfile("/proc/self/mounts")
            for line in MNTS.splitlines():
                  let parts = line.splitwhitespace()
                  if parts.len >= 2 and parts[1] == target:
                        return true
            return false
      else:
            return false

## Mounter
proc mounter*[T](source, target, fstype: T, flag: uint, data: pointer): cint {.inline.} =
      var src, tgt, fs: cstring
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
            if not mountchecker(tgt):
                  let ret = mount(src, tgt, fs, flag, data)
                  if ret == 0:
                        let successmsg = ("Mounted " & $src & " (" & $fs & ") at " & $tgt)
                        tmesg(ret, successmsg)
                        discard vfsinfo(tgt)
                        success = true
                  else:
                        var count = 0
                        while count < 3:
                              if not mountchecker(tgt):
                                    let errormsg = ("Failed to mount " & $src & " (" & $fs & ") at " & $tgt)
                                    tmesg(ret, errormsg)
                                    stderr.write(YELLOW & "Retrying...")
                                    success = false
                              else:
                                    success = true

            else:
                  let msg = ($src & " (" & $fs & ") at " & $tgt & " is already mounted")
                  tmesg(0, msg)
                  success = true
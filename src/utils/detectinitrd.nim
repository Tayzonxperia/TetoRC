import os

proc inInitramfs*(): bool =

    #[ /etc/initrd-release exists? In initramfs
       If it doesn't exist, check for pivot_root dirs ]#

   if fileExists("/etc/initrd-release"): return true
   if dirExists("/newroot") or dirExists("/sysroot"): return true
   if not dirExists("/home"): return true
   
   #[ /newroot and /sysroot usually only exist in initrd
      and /home rarely exists in initrd... ]#



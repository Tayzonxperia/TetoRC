import posix, os

import "../../ct/constants"
import "../../sys/file/generic"
import "../../sys/mount/generic"


{.compile: "/../../sys/init/birdbrain.c".}
{.compile: "/../../sys/init/init.c".}
{.compile: "/../../sys/init/shutdown.c".}
{.compile: "/../../sys/init/signal.c".}
{.passL: "-LBuild/lib -lteto".}

proc c_main {.importc, cdecl.}

## START ##
###########

discard kill(getpid(), SIGSEGV)

## All we do currently is test ERROR HANDLING as if
## we fuck this up, we are univerally fucked
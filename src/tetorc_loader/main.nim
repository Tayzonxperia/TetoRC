import posix, os

import "../data/constants"
import "../core/sighandler", "../core/log"

{.compile: "../data/teto_section.c".}

## START ##
###########
echo("Hello") # Test

regSigHandler() # Register signals

discard kill(getpid(), SIGSEGV) # Die, to test error handling

## All we do currently is test ERROR HANDLING as if
## we fuck this up, we are univerally fucked :P
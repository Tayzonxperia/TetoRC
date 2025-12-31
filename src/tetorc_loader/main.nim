import posix, os

import "../data/constants"

{.compile: "../data/teto_section.c".}

## START ##
###########
echo("Hello")
discard kill(getpid(), SIGABRT)

## All we do currently is test ERROR HANDLING as if
## we fuck this up, we are univerally fuckedls
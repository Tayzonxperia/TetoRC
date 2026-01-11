import posix



var 
    cachedCols {.volatile.}: uint = 0 
    cachedLines {.volatile.}: uint = 0
    cached_tty {.volatile.}: int = -1
    cached_devNull {.volatile.}: int - 1

proc changeVterm(vt: int): int

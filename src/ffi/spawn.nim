import posix



type 
    SchedParam* = object
        SchedPriority*: cint

    PosixSpawnAttr* {.importc: "__posix_spawnattr", header: "<spawn.h>".} = object
    PosixSpawnFileActions* {.importc: "__posix_spawn_file_actions", header: "<spawn.h>".} = object


const
    POSIX_SPAWN_RESETIDS*        = 0x01
    POSIX_SPAWN_SETPGROUP*       = 0x02
    POSIX_SPAWN_SETSCHEDPARAM*   = 0x04
    POSIX_SPAWN_SETSCHEDULER*    = 0x08
    POSIX_SPAWN_SETSIGDEF*       = 0x10
    POSIX_SPAWN_SETSIGMASK*      = 0x20


proc posix_spawn*(
    pid: ptr Pid,
    path: cstring,
    fileactions: ptr PosixSpawnFileActions,
    attr: ptr PosixSpawnAttr,
    argv: ptr ptr cchar,
    envp: ptr ptr cchar):
    cint {.importc, header: "<spawn.h>".}

when not defined(tiny) or not defined(loader):
    proc posix_spawnp*(
        pid: ptr Pid,
        path: cstring,
        fileactions: ptr PosixSpawnFileActions,
        attr: ptr PosixSpawnAttr,
        argv: ptr ptr cchar,
        envp: ptr ptr cchar):
        cint {.importc, header: "<spawn.h>".}


when not defined(tiny) or not defined(loader):
    proc posix_spawn_file_actions_init*(
        actions: ptr PosixSpawnFileActions):
        cint {.importc, header: "<spawn.h>".}

    proc posix_spawn_file_actions_destroy*(
        actions: ptr PosixSpawnFileActions): 
        cint {.importc, header: "<spawn.h>".}

    proc posix_spawn_file_actions_addopen*(
        actions: ptr PosixSpawnFileActions,
        fd: cint,
        path: cstring,
        oflag: cint,
        mode: Mode):
        cint {.importc, header: "<spawn.h>".}

    proc posix_spawn_file_actions_adddup2*(
        actions: ptr PosixSpawnFileActions,
        fd: cint,
        newfd: cint): 
        cint {.importc, header: "<spawn.h>".}

    proc posix_spawn_file_actions_addclose*(
        actions: ptr PosixSpawnFileActions,
        fd: cint): 
        cint {.importc, header: "<spawn.h>".}

    proc posix_spawnattr_init*(
        attr: ptr PosixSpawnAttr): 
        cint {.importc, header: "<spawn.h>".}

    proc posix_spawnattr_destroy*(
        attr: ptr PosixSpawnAttr): 
        cint {.importc, header: "<spawn.h>".}

    proc posix_spawnattr_setflags*(
        attr: ptr PosixSpawnAttr, 
        flags: cint): 
        cint {.importc, header: "<spawn.h>".}

    proc posix_spawnattr_setpgroup*(
        attr: ptr PosixSpawnAttr,
        pgid: Pid):
        cint {.importc, header: "<spawn.h>".}


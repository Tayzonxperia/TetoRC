import posix



proc asprintf*(
    str: ptr cstring,
    fmt: cstring):
    cint {.cdecl, importc: "asprintf", header: "<stdio.h>", varargs.} 

proc snprintf*(
    str: ptr char,
    size: csize_t,
    fmt: cstring):
    cint {.cdecl, importc: "snprintf", header: "<stdio.h>", varargs, inline.}
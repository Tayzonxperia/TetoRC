import posix




## START ##
###########

type MountFlags* = enum
    MS_RDONLY        = 1 shl 0
    MS_NOSUID        = 1 shl 1
    MS_NODEV         = 1 shl 2
    MS_NOEXEC        = 1 shl 3
    MS_SYNCHRONOUS   = 1 shl 4
    MS_REMOUNT       = 1 shl 5
    MS_MANDLOCK      = 1 shl 6
    MS_DIRSYNC       = 1 shl 7
    MS_NOSYMFOLLOW   = 1 shl 8
    MS_NOATIME       = 1 shl 10
    MS_NODIRATIME    = 1 shl 11
    MS_BIND          = 1 shl 12
    MS_MOVE          = 1 shl 13
    MS_REC           = 1 shl 14
    MS_SILENT        = 1 shl 15
    MS_POSIXACL      = 1 shl 16
    MS_UNBINDABLE    = 1 shl 17
    MS_PRIVATE       = 1 shl 18
    MS_SLAVE         = 1 shl 19
    MS_SHARED        = 1 shl 20
    MS_RELATIME      = 1 shl 21
    MS_I_VERSION     = 1 shl 23
    MS_STRICTATIME   = 1 shl 24
    MS_LAZYTIME      = 1 shl 25
    MS_ACTIVE        = 1 shl 30
    MS_NOUSER        = 1 shl 31


type UmountFlags* = enum
    MNT_FORCE       = 1
    MNT_DETACH      = 2 
    MNT_EXPIRE      = 4
    UMOUNT_NOFOLLOW = 8


type MountState* = enum
    Failed, Mounted, AlreadyMounted

type MountEntry* = object
    source*, target*, fsType*: cstring
    flags*: uint
    data*: pointer
    mandatory*: bool
    state*: MountState
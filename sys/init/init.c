#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

#include <sys/reboot.h>
#include <linux/reboot.h>

#include "birdbrain.h"
#include "init.h"

static void mount_pseudo_filesystems(void);
static void seed_rng_device(void);
static void set_hostname(void);
static void disable_three_finger_salute(void);

void boot_system() {;

    execute("/kasane/tetorc/sh/interlude");

    disable_three_finger_salute();
    execute("/kasane/tetorc/sh/tty");
}

static void disable_three_finger_salute() {
    // Pressing Ctrl+Alt+Del before this call will cause a system reboot. // Do we even need this?
    reboot(LINUX_REBOOT_CMD_CAD_OFF);
}

void drop_to_emergency_shell() {
    fputs("Init failed, dropping into emergency root shell.", stderr);
    execute("/bin/bash"); // Bash, because sh is ass, and almost always symlink to bash anyway :p
}

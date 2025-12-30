#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <fcntl.h>
#include <unistd.h>
#include <mntent.h>
#include <sys/syscall.h>
#include <sys/mount.h>
#include <linux/random.h>

#include "birdbrain.h"
#include "shutdown.h"

static void unmount_filesystems(void);
static void clear_directory(char*);
static void seed_rng_device(void);

void shutdown_system() {
    execute("/kasane/tetorc/sh/shutdown");
    clear_directory("/tmp");
    sync();

    unmount_filesystems();
}

static void unmount_filesystems() {
    struct mntent *mount_point;
    FILE *mounts = setmntent("/proc/mounts", "r");

    if (!mounts)
        return; // Well this is an issue.

    while ((mount_point = getmntent(mounts)))
        if (strcmp(mount_point->mnt_dir, "/") == 0 || umount(mount_point->mnt_dir) < 0)
            mount(NULL, mount_point->mnt_dir, NULL, MS_REMOUNT | MS_RDONLY, NULL);
        // if unmount fails, mount as read only

    endmntent(mounts);
}

static void clear_directory(char *temp_path) {
    DIR *directory;
    struct dirent *entry;
    int strlen_temp_path = strlen(temp_path) + 1;

    directory = opendir(temp_path);

    if (!directory)
        return;

    char *full_path;
    while ((entry = readdir(directory))) {
        full_path = (char *)calloc(strlen_temp_path + strlen(entry->d_name), sizeof(char));

        if (!full_path)
            continue;

        sprintf(full_path, "%s/%s", temp_path, entry->d_name);
        remove(full_path);

        free(full_path);
    }

    closedir(directory);
}

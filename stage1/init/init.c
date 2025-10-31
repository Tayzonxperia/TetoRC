//////// TetoRC Stage 1 Birdbrain init file
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/reboot.h>
#include <linux/reboot.h>

// Include imports
#include "../../include/birdbrain.h"
#include "../../include/init.h"

// Function defines
static void seed_rng_device(void);
static void set_hostname(void);
static void disable_three_finger_salute(void);



void boot_system() 
{
    execute("/kasane/tetorc/tbin/fs");

    set_hostname();
    seed_rng_device();

    execute("/kasane/tetorc/tbin/interlude");

    disable_three_finger_salute();

    execute("/kasane/tetorc/tbin/tty");
    //start_tetorc_s2(); 
    /* Disabled for now - Agetty will not work when launched from my test VM 
       for some reason, root will not login - Think its because my /bin/login 
       does not link to libpam, i use shadowed passwds */
                
}

static void seed_rng_device() 
{
    void *seed;
    struct stat status;
    int fd = open("/kasane/tetorc/misc/random.seed", O_RDONLY);

    if (fd < 0 || fstat(fd, &status) < 0)
        return;

    seed = mmap(0, status.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    close(fd);

    if (seed == MAP_FAILED)
        return;

    fd = open("/dev/urandom", O_WRONLY);

    if (fd < 0)
        return;

    write(fd, seed, status.st_size);
    close(fd);
    munmap(seed, status.st_size);
}

static void set_hostname() 
{
    struct stat status;
    void *mapped_file = MAP_FAILED;
    char *hostname = "teto";
    int fd = open("/etc/hostname", O_RDONLY);

    if (fd < 0 || fstat(fd, &status) < 0)
        hostname = "teto";
    else {
        mapped_file = mmap(0, status.st_size, PROT_READ, MAP_PRIVATE, fd, 0);

        if (mapped_file != MAP_FAILED)
            hostname = (char *)mapped_file;

        close(fd);
    }

    fd = open("/proc/sys/kernel/hostname", O_WRONLY);
    write(fd, (void *)hostname, strlen(hostname));
    close(fd);

    if (mapped_file != MAP_FAILED)
        munmap(mapped_file, status.st_size);
}

static void disable_three_finger_salute() 
{
    // Pressing Ctrl+Alt+Del before this call will cause a system reboot.
    reboot(LINUX_REBOOT_CMD_CAD_OFF);
}

void drop_to_emergency_shell() 
{
    fputs("Init failed, dropping into emergency root shell \n", stderr);
    while (1) {
        pid_t pid = fork();
        if (pid == 0) {
            execl("/bin/bash", "tetobash", NULL);
            fprintf(stderr, "Failed to exec emergency bash shell: %s\n \n", strerror(errno));
            _exit(1);
        } else if (pid > 0) {
            int status;
            waitpid(pid, &status, 0);
            fprintf(stderr, "Shell exited (status %d), restarting...\n \n", WEXITSTATUS(status));
        } else {
            fprintf(stderr, "fork() failed: %s\n \n", strerror(errno));
            sleep(1);
        }
    }
}

void start_tetorc_s2(void) 
{
    const char *mtarget = "/sbin/tetorc-stage2"; 
    char *const margv[] = { (char *)mtarget, NULL };
    char *const menvp[] = { NULL };
    const char *starget = "/kasane/tetorc/tetorc-stage2"; 
    char *const sargv[] = { (char *)starget, NULL };
    char *const senvp[] = { NULL };

    int attempts = 0;

    while (attempts < 3) {
        execve(mtarget, margv, menvp);
        fprintf(stderr, "Main execve(%s) failed: %s\n", mtarget, strerror(errno));
        execve(starget, sargv, senvp);
        fprintf(stderr, "Secondary execve(%s) failed: %s\n", starget, strerror(errno));
        attempts++;
        sleep(1);
    }

    // All retries failed — start emergency shell loop
    fprintf(stderr, "\nFailed to execve %s or %s after %d attempts. Spawning a bash shell...\n \n", mtarget, starget, attempts);

    while (1) {
        pid_t pid = fork();
        if (pid == 0) {
            execl("/bin/bash", "tetobash", NULL);
            fprintf(stderr, "Failed to exec emergency bash shell: %s\n \n", strerror(errno));
            _exit(1);
        } else if (pid > 0) {
            int status;
            waitpid(pid, &status, 0);
            fprintf(stderr, "Shell exited (status %d), restarting...\n \n", WEXITSTATUS(status));
        } else {
            fprintf(stderr, "fork() failed: %s\n", strerror(errno));
            sleep(1);
        }
    }

}
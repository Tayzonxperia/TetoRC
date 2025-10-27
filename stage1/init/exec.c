//////// TetoRC init exec file
#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <errno.h>
#include <string.h>
#include <sys/wait.h>
#include "../../include/exec.h"


int start_tetorc_s2(void) {
    const char *mtarget = "/sbin/tetorc-stage2"; 
    char *const margv[] = { (char *)mtarget, NULL };
    char *const menvp[] = { NULL };
    const char *starget = "/usr/libexec/tetorc-stage2"; 
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

    return 0;
}


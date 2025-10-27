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


void start_bash(void) {
    while (1) {
        pid_t pid = fork();
        if (pid == 0) {
            execl("/bin/bash", "tetobash", NULL);
            fprintf(stderr, "Failed to exec tetobash shell: %s\n \n", strerror(errno));
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
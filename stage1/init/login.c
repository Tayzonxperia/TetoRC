//////// TetoRC init login file
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include "../../include/login.h"

void start_bash(void) {
        while (1) {
                pid_t pid = fork();
                if (pid == 0) {
                        execl("/bin/bash", "/bin/bash", NULL);
                        perror("execl bash");
                        exit(1);
                }

                int status;
                waitpid(pid, &status, 0);
                printf("\n Shell killed! Respawning new shell... \n");
        }
}
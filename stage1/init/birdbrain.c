//////// TetoRC Stage 1 Birdbrain main file
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>

// Include imports
#include "../../include/birdbrain.h"
#include "../../include/init.h"
#include "../../include/shutdown.h"
#include "../../include/signal.h"



void execute(char *path) {
    if (access(path, X_OK) < 0)
        return;

    char *command[] = {path, NULL};

    pid_t pid = fork();

    if (pid == 0)
        execv(path, command);
    else if (pid) {
        do {
            waitpid(pid, NULL, 0);
        } while (errno == EINTR);
    }
}

int cmain(int argc, char **argv) {

    install_signal_handler();
    boot_system();
    drop_to_emergency_shell(); // Backup bash :p
    handle_signal(SIGINT); // Reboot machine

    return EXIT_FAILURE; // If this happens, well... fuck
}

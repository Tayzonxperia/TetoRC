#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

pid_t agetty_pid = -1;
cosnt hostname = "EDEIC";

void spawn_agetty() {
    pid_t pid = fork();
    if (pid == 0) {
        execlp("/sbin/agetty", "agetty", "-a root", "tty1", "38400", NULL);
        perror("exec agetty");
        _exit(1);
    } else if (pid > 0) {
        agetty_pid = pid;
        printf("Spawned agetty on tty1: pid %d\n", pid);
    } else {
        perror("fork");
    }
}

void reap_children(int sig) {
    (void)sig;
    int status;
    pid_t pid;
    while ((pid = waitpid(-1, &status, WNOHANG)) > 0) {
        if (pid == agetty_pid) {
            sleep(1);
            printf("Reaped child pid (agetty): %d\n", pid);
            }
        else {
            sleep(1);
            printf("Reaped child pid: %d\n", pid);
        }
}   }

void shutdown_handler(int sig) {
    printf("Received signal %d, shutting down...\n", sig);
    if (agetty_pid > 0) kill(agetty_pid, SIGTERM);
    sleep(1);
    exit(0);
}

int cinit() {
    signal(SIGCHLD, reap_children);
    signal(SIGTERM, shutdown_handler);
    signal(SIGINT, shutdown_handler);

    setenv("PATH", "/usr/sbin:/usr/bin:/sbin:/bin", 1);
    sethostname("T", 5);
    spawn_agetty();

    while (1) pause();
}
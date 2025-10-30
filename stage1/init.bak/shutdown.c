//////// TetoRC init login file
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <sys/reboot.h>
#include "../../include/shutdown.h"

void shutdown_sys(int reboot_flag) { // Shutdown system or reboot system
        printf("TetoRC is shutting down... \n (Writing changes - Do not force power off!) ");
        sync();
        printf("%s system...\n", reboot_flag ? "Rebooting" : "Shutting down");
        reboot(reboot_flag ? RB_AUTOBOOT : RB_POWER_OFF);
}
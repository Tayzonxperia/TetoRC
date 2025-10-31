//////// TetoRC Birdbrain signal header file
#pragma once

// Header includes
#include <signal.h>



#ifndef SIGUNUSED
#define SIGUNUSED SIGSYS
#endif

extern int (*signal_map[SIGUNUSED])(void);

void handle_signal(int);
void install_signal_handler(void);
int restart_machine(void);
int poweroff_machine(void);
int reap_children(void);

Building TetoRC

To build TetoRC, run the build script located at:
~/Projectroot/Build/compile.sh

This script provides an interactive prompt that lets you choose how to compile TetoRC depending on your needs.

Build Profiles

The Nim compiler supports build-time definitions (-d:define flags) that let you toggle features or optimize the binary for different use cases.
The build script presents four preset configurations:

1. Standard

Builds a regular release binary suitable for general use.

2. Debug

Builds a debug binary with verbose output and debugging symbols.
Use this for testing, development, or diagnosing runtime behavior.

3. Optimized

Builds a system-optimized binary tuned for performance on your hardware.
Note: compile times will increase due to higher optimization levels, and 
may break on some machines.

4. Tiny

Builds the smallest possible binary by disabling nonessential features.
Ideal for embedded or minimalist systems.


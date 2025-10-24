#### About TetoRC

TetoRC is a fast, stable and Nim-based init system which aims to provide a appealing, lightning fast and featureful
init system using the high level but really powerful language, Nim, which compiles directly to C code, and binary.

This means that its overhead is limited, but its source can still make it faster to build and prototype VS C code.
Note: It is language agnostic, meaning any turing language theroetically can be integrated with it, but it is mainly
Nim based. It was made for the TetOS project, a Linux distribution thats in development and not released yet

## Navigating the source root of TetoRC

~/Projectroot refers to the source directory where
TetoRC tree is located.

The directories usually present (subject to change) are:

core/ - Main code for the main file, loggers and code needed 
for program to run

fs/ - Code for mounting, interacting with Virtual Filesystem and swap

settings/ - Files that hold mostly variables, simple logic and
config files

tools/ - Files TetoRC can use, but that could also be used elsewhere

include/ - Header files and files defining code

samples/ - Proof of concepts or precompiled test binaries
to run in a VM for the user to test TetoRC and see if
it works for them

Build/ - Build scripts 

Documentation/ - Manuals or docs explaining how TetoRC works or can be used
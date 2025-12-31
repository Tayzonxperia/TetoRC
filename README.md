# TetoRC – Rapid, Flexible Init System

> Kimi wa jitsu ni baka dana

---

## Overview

TetoRC is a **rapid, flexible init system** written in **Nim**, designed for **performance and ease of use**.  
It aims to demonstrate that modern languages can handle low-level system tasks while keeping source code **readable** and **maintainable**.
Some C is used, but we plan to fully migrate to Nim soon, once we can port it.

---

## Status

- **Multiple stages for redundancy** –> planned but **not yet implemented**.  
- **Heavy beta** –> not expected to work reliably. This is currently a **one-woman project :3**.  
- Still exploring **Compile-Time Execution (CTE)** for maximum flexibility and speed, this will also allow extreme optimization in future.  

---

## Install how-to

- To compile TetoRC, run the **build.nims** script either by running `./build.nims` or `nim e build.nims`
- Files produced will be in **Build** directory, either *bin* for executables or *lib* for shared libaries 
- To install TetoRC, you will have to copy it manually, put the libaries in **/usr/lib** and the binaries in **/usr/sbin**
- If installing as PID1, in a VM *(risky on real hardware currently)*, **symlink /sbin/tetorc-stage1 to /sbin/init**

---

## Goals

- Prove that an **init system can be written in a modern language** - *(Fuck you, Rust)*.  
- Leverage Nim’s **compile-time execution** features and tooling.  
- Maintain **human-readable, modular source**.  

---

## Notes

> Meow mrrp nya :3

- Because why shouldn’t an init system have personality?  
- Chaos and cuteness are optional, but encouraged.
- If you have taken a intrest in this... (next line)
- You must be a nerd, come on - *TetoRC* - just a transfem's cute little init :3

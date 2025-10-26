🧠 TetoRC — A Fast, Modern, Nim-Based Init System

TetoRC is a lightning-fast, stable, and modular init system written primarily in Nim — a powerful high-level language that compiles directly to optimized C.

Unlike traditional init systems written entirely in C, TetoRC takes advantage of Nim’s expressive syntax, meta-programming, and compile-time optimizations to deliver high performance with low overhead, while still being clean, readable, and extensible.

TetoRC is also multi-stage, split into 2 (and optionally 3) stages to improve redundancy.

⚙️ Philosophy

TetoRC was built to prove that speed and elegance can coexist.
It powers the TetOS project — a Linux distribution currently in development — and aims to demonstrate that a hybrid, multi-language approach can rival traditional monolithic init systems like SysV, OpenRC, or systemd.

Key goals:

Performance: Compiles to optimized C with minimal runtime overhead.

Reliability: Built around stable and well-understood POSIX semantics.

Flexibility: Language-agnostic — any Turing-complete language can integrate with it.

Hackability: Minimal boilerplate; clean architecture that encourages experimentation.


🚀 Why Nim?

Nim bridges the gap between low-level control and high-level expressiveness.
It generates C, C++, or Objective-C code directly, allowing developers to:

Write expressive, readable code.

Avoid complex build systems (no makefiles or cmake hell).

Mix in C libraries and system calls using importc pragmas.

Use compile-time evaluation (static, const, macros) for maximum efficiency.

Direct use of system calls via importc.

Compile-time metaprogramming (static, macro, const).

Optional garbage collection — or none at all for kernel-level performance.

Rapid prototyping with native binary output and zero interpreter overhead.

This means TetoRC can be developed and prototyped faster than C projects, while achieving similar — or even superior — performance.


🧬 Language Agnosticism

While Nim is the backbone, TetoRC welcomes contributions in other languages — including C,C++, Rust, Lua, or even Assembly — as long as they adhere to the project’s modular interface system.

This design allows developers to:

Replace or extend subsystems using different languages.

Integrate external tools or binaries seamlessly.

Prototype new functionality without rewriting the entire core.

And allows for greater development contibutions.


⚡ Performance & Efficiency

TetoRC’s design ensures:

Minimal startup time (milliseconds-level on tested systems).

Memory footprint comparable to SysVinit and OpenRC.

Near-zero CPU load during idle states.

Static binary compilation with full control over GC and linking, while also dynamic linked when needed.

Even when running high-level Nim logic, GC can be disabled, and memory management falls back to deterministic stack-based allocation — effectively achieving C-like performance (although not yet supported, Nim allows this at any time, and it will soon be supported).

🧩 Source Layout:

~/Projectroot is where all this is set out.

stage* (* being a number) refers to the binary stage, increasing numbers are more complex

Directory	Purpose

core/ -	Main logic and subsystem.

fs/	- Filesystem operations — mounts, swap, VFS and read/write.

init/ - PID1 signal processing and service management.

ipc/ - Process communication.

include/ - Header and interface definitions for imports.

modules/ - Add-ons that TetoRC can call.

Build/ - Compilation scripts and environment setup.

Documentation/ - Manuals, guides, and developer docs.


🌐 Future Goals

Full service supervision (start/stop/restart daemons safely).

Socket-based IPC for high-speed event communication.

REPL-powered dynamic management of services.

Integration with tetoservice for full OS orchestration.

### TetoRC — rewriting the concept of init systems,

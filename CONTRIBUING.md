# TetoRC Coding Style Guide

**Version 1.1 — Authored by Taylor (Tayzonxperia)**  
*Designed for Nim, C, and Bash — maximum readability, logical rhythm, and aesthetic structure.*

---

## Purpose

This document defines the **TetoRC Coding Standard** — a unified style philosophy ensuring clarity, predictability, and aesthetic consistency across all code written for the TetoRC ecosystem.

TetoRC code should look intentional, read like structured architecture, and communicate purpose visually.

---

## Core Principles

1. **Readability is king.** Code is read more than it’s written.  
2. **Consistency creates rhythm.** Identical patterns lower mental overhead.  
3. **Structure mirrors logic.** Indentation and braces are cognitive signposts.  
4. **No wasted symbols.** Every space, brace, and comment has a reason.

---

## Indentation and Alignment

- **Tabs** are required for Nim.  
- **Tabs or 4 spaces** are acceptable for C and Bash.  
  - *Equivalence:* `1 tab = 4 spaces`.  
- **Operators** should be surrounded by a single space:  
  ```c
  int result = a + b;
  ```
- **Blank lines** are used sparingly — to visually separate code blocks or logical sections.

---

## Braces and Parentheses Style

Each bracket or parenthesis occupies its own line — never attached to function names or control statements.

### Example — C
```c
int add
(
    int a,
    int b
)
{
    return a + b;
}
```

### Example — Nim
```nim
proc add
(
    a: int,
    b: int
): int =
    return a + b
```

### Example — Bash
```bash
add()
(
    local a="$1"
    local b="$2"
    echo $((a + b))
)
```

**Rationale:**  
This visually isolates code blocks and enhances vertical readability — especially useful for low-level or nested logic.

---

## Naming Conventions

| Type | Nim | C | Bash | Example |
|------|-----|---|-------|----------|
| Mutable variable | `var_name` | `var_name` | `var_name` | `var result` |
| Immutable variable | `LET_NAME` | `const LET_NAME` | `readonly LET_NAME` | `let LET_NAME=42` |
| Constant | `CONSTNAME` | `#define CONSTNAME` | N/A | `CONSTNAME = 64` |
| Enum / Struct / Type | `ObjectName` | `StructName` | — | `UserInfo`, `IPCData` |

### Function Naming
- All lowercase or snake_case (`start_ipc`, `spawn_process`).  
- Short, clear, and action-oriented.  
- Prefer multiple small, single-purpose functions over one long monolith.

---

## Comment Hierarchy (Universal System)

TetoRC code uses a hierarchical comment system consistent across Nim, Bash, and C.

| Purpose | Nim | Bash | C | INI |
|----------|-----|------|--|------|
| File Header | `########` | `########` | `////////` | `;;;;;;;;`
| Major Section | `####` | `####` | `////` | `;;;;`
| Minor Section / Block | `##` | `##` | `/* */` | `;;`
| Inline Comment | `#` | `#` | `//` | `;`

### Example — C
```c
////////
// TetoRC Init Manager
// Core Logic
////////

// Function to start IPC listener
int start_ipc()
{
    // Initialize socket
    int socket = init_socket();
}
```

### Example — Nim
```nim
########
## TetoRC Init Manager
## Core Logic
########

## Function to start IPC listener
proc start_ipc(): void =
    # Initialize socket
    var socket = createSocket()
```

### Example — Bash
```bash
########
## TetoRC Init Manager
## Core Logic
########

## Function to start IPC listener
start_ipc()
(
    # Initialize socket
    echo "Starting IPC..."
)
```

---

## File Layout Convention

1. **File Header**
   - Name, purpose, author, license.
2. **Imports / Includes**
3. **Constants and Globals**
4. **Function Definitions**
5. **Main Entry Point**
6. **Footer (optional)**  
   Example:
   ```c
   ////// END OF FILE //////
   ```

---

## Style Enhancements

- Align parameters and assignments vertically where practical:
  ```c
  int a   = 5;
  int sum = a + b;
  ```
- Group related functions with visible headers:
  ```c
  //// Process Management ////
  ```

---

**End of TetoRC Style Guide**
````

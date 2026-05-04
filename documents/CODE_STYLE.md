# Code Style

---
> SPDX-License-Identifier: GPL-3.0-only \
> Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
---


## Formatting:

We use a consistent, firm, and efficient formatting scheme throughout the TetoRC codebase. Note that temporary code, or development branches need not follow this.

- Use the provided `.editorconfig` to ensure the proper tabs and widths are applied. We use **4** char indent, tabs are **NOT** allowed unless your editor converts them to spaces
automatically. Maximum line length is **110** chars; recommended is **90–100**~ chars.

- We require a license identifier at the beginning of every file, also with top-level module comments for files of any importance, including module root files. Here is a Zig example:
```zig
// SPDX-License-Identifier: <LICENCE>
// Copyright (C) <START>-<CURRENT> <NAME> (<IDENTIFIER>)
//! Explanation of module, uses, functionality, and potential pitfalls, etc...
```
Documentation comments (`///`) should also be used where it would make sense, especially for large structs or complex functions. Please reserve regular comments (`//`) for small
explanations, hacks, or local (uncommitable) uses.

- Module organization should be strictly alphabetical, and should be spaced out evenly. Do not alias to a different identifier, so we can always trace them back again. For
example, do this:
```zig
const ExampleModule = @This();

const std = @import("std");
const builtin = std.builtin;
const mem = std.mem;

const AnotherModule = @import("AnotherModule");
const AnotherStruct = AnotherModule.AnotherStruct;
```
But avoid:
```zig
const ExampleModule = @This();
const AnotherModule = @import("AnotherModule");
const AnotherModule_AnotherStruct = AnotherModule.AnotherStruct;
const std = @import("std");
const std_builtin = std.builtin;
const std_memory = std.mem;
```


## Styling

We follow a strict and consistent styling scheme across the entire TetoRC codebase. Development or testing branches may temporarily diverge, but all release code must follow these rules.

- If a function declaration is broken up over multiple lines, and is at the file-scope, make sure it looks something like this:
```zig
pub fn someFunction(
    foo: u8,
    bar: u16,
    baz: u32) void
{

    const meow = (foo + bar) * baz;
}
```
And if it is at a function-scope, aim for:
```zig
pub fn someFunction(
    foo: u8,
    bar: u16,
    baz: u32) void {

    const meow = (foo + bar) * baz;
}
```
Leave a newline for the first declaration in these functions.


### Functions

#### Names

| Type | Naming Style | Example |
|------|--------------|---------|
| Runtime/Standard | `camelCase` | `runtimeFunction()` |
| Comptime/Macro | `ALL_CAPS` | `COMPTIME_FUNCTION()` |

#### Parameters

| Type | Naming Style | Example |
|------|--------------|---------|
| Runtime/Standard | `snake_case` (<5 chars) | `runtime_parameter` |
| Comptime/Macro | `ALL_CAPS` (>5 chars) | `RT_PM` |


### Data (Structs/Enums/Unions)

#### Name

| Type | Naming Style | Example |
|------|--------------|---------|
| Runtime/Standard | `PascalCase` | `RuntimeData` |
| Comptime/Macro | `ALL_CAPS` | `COMPTIME_DATA` |

#### Fields

| Type | Naming Style | Example |
|------|--------------|---------|
| Public | `snake_case` (No leading underscore) | `public_field` |
| Private | `snake_case` (1 leading underscore) | `_private_field` |
| Reserved | `snake_case` (2 leading underscores)| `__reserved_field` |


### Data (Variables/Constants)

#### Variables

| Type | Naming Style | Example |
|------|--------------|---------|
| Function-scoped | `camelCase` | `functionVariable` |
| File-scoped | *N/A* | *N/A* |

#### Constants

| Type | Naming Style | Example |
|------|--------------|---------|
| Function-scoped | `camelCase` | `functionConstant` |
| File-scoped | `ALL_CAPS` | `FILE_CONSTANT` |


### Control flow

#### Braces

We use hybrid brace styles to improve readability and signal locality.

- Function-scoped braces are to use the K&R style:
```zig
if (foo.bar == foo.baz) {
    try bar.baz();
}
```

- File-scoped braces are to use Allman's style:
```zig
pub fn foo(bar: u8) void
{
    const baz = bar + 10;
    return baz * 100;
}
```

// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! **TetoRC compile-time configuration values.**
//!
//! This module contains 2 splits:
//!
//! - `BUILD_OPTIONS`:
//! Values that were available to the user who compiled this software.
//! Such values include feature flags, target triple and compilation mode.
//!
//! - `BUILD_POLICY`:
//! Values that were automatically decided by the software's build system.
//! Such values include optimization flags, debugging support (decided based
//! on compilation mode) and LLVM usage.
//!
const ComptimeConfig = @This();

const CompileOptions = @import("CompileOptions");
const CompilePolicy = @import("CompilePolicy");

const build_options = @import("build_options.zig");
const build_policy = @import("build_policy.zig");



pub const BUILD_OPTIONS: build_options = build_options.init(
    CompileOptions.builtin_OptimizeMode,
    CompileOptions.builtin_LinkMode,
    CompileOptions.builtin_CodeModel,
    CompileOptions.Target_Cpu_Arch,
    CompileOptions.Target_Os_Tag,
    CompileOptions.Target_Abi);

pub const BUILD_POLICY: build_policy = build_policy.init(
    CompilePolicy.has_strip,
    CompilePolicy.has_stack_protector,
    CompilePolicy.has_stack_check,
    CompilePolicy.has_valgrind,
    CompilePolicy.has_omit_frame_pointer,
    CompilePolicy.has_force_llvm,
    CompilePolicy.has_force_lld);



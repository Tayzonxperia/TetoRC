// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! # TetoRC build system module mutater.
const ModuleFactory = @This();

const std = @import("std");
const Build = std.Build;

const StaticConfig = @import("StaticConfig.zig");
const DynamicConfig = @import("DynamicConfig.zig");



pub fn make(
    name:           []const u8,
    file:           []const u8,
    static_config:  StaticConfig,
    dynamic_config: DynamicConfig,
    b:              *Build) *Build.Module
{

    return b.addModule(name, .{
        .root_source_file = b.path(file),
        .optimize = static_config.compilation_flags.optimizemode,
        .code_model = static_config.compilation_flags.codemodel,
        .target = dynamic_config.resolved_target,
        .strip = dynamic_config.strip,
        .stack_protector = dynamic_config.stack_protector,
        .stack_check = dynamic_config.stack_check,
        .valgrind = dynamic_config.valgrind,
        .omit_frame_pointer = dynamic_config.omit_frame_pointer,
    });
}

pub const Import = struct
{
    name:   []const u8,
    module: *Build.Module,
};

pub fn importInto(
    module:     *Build.Module,
    imports:    []const Import) void
{

    for (imports) |i|
    { module.addImport(i.name, i.module); }
}

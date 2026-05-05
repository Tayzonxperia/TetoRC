// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC build utility to register and assign modules quickly and safely.
const ModuleRegister = @This();

const std = @import("std");
const builtin = std.builtin;
const Build = std.Build;
const Target = std.Target;

const MessageLogger = @import("MessageLogger.zig");
const CompileOptions = @import("CompileOptions.zig");
const CompilePolicy = @import("CompilePolicy.zig");



optimizemode:       ?builtin.OptimizeMode = null,
codemodel:          ?builtin.CodeModel = null,
resolvedtarget:     ?Build.ResolvedTarget = null,
single_threaded:    ?bool = null,
strip:              ?bool = null,
stack_protector:    ?bool = null,
stack_check:        ?bool = null,
valgrind:           ?bool = null,
omit_frame_pointer: ?bool = null,


pub fn add(
    name:       []const u8,
    file:       []const u8,
    overrides:  @This(),
    opts:       CompileOptions,
    pol:        CompilePolicy,
    tgt:        Build.ResolvedTarget,
    b:          *Build) *Build.Module
{

    MessageLogger.logMessage(
        MessageLogger.Level.expr,
        "Adding module <{s}> (file: <{s}>) to register...",
        .{name, file});

    const root_source_file = b.path(file);
    const optimizemode: builtin.OptimizeMode = overrides.optimizemode orelse opts.optimizemode;
    const codemodel: builtin.CodeModel = overrides.codemodel orelse opts.codemodel;
    const resolvedtarget: Build.ResolvedTarget = overrides.resolvedtarget orelse tgt;
    const single_threaded: bool = overrides.single_threaded orelse opts.single_threaded;
    const strip: bool = overrides.strip orelse pol.strip;
    const stack_protector: bool = overrides.stack_protector orelse pol.stack_protector;
    const stack_check: bool = overrides.stack_check orelse pol.stack_check;
    const valgrind: bool = overrides.valgrind orelse pol.valgrind;
    const omit_frame_pointer: bool = overrides.omit_frame_pointer orelse pol.omit_frame_pointer;

    return b.addModule(name, .{
        .root_source_file = root_source_file,
        .optimize = optimizemode,
        .code_model = codemodel,
        .target = resolvedtarget,
        .single_threaded = single_threaded,
        .strip = strip,
        .stack_protector = stack_protector,
        .stack_check = stack_check,
        .valgrind = valgrind,
        .omit_frame_pointer = omit_frame_pointer,
        });
}

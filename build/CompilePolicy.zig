// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC compilation policy options that are decided from a CompileOptions struct
const CompilePolicy = @This();

const std = @import("std");
const Build = std.Build;
const debug = std.debug;

const MessageLogger = @import("MessageLogger.zig");
const CompileOptions = @import("CompileOptions.zig");



strip:              bool,
stack_protector:    bool,
stack_check:        bool,
valgrind:           bool,
omit_frame_pointer: bool,
force_llvm:         bool,
force_lld:          bool,


pub fn fromCompileOptions(opts: CompileOptions) CompilePolicy
{
    const strip: bool = determine: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Determining <{s}> policy...",
            .{"strip"});

        break :determine switch (opts.optimizemode) {
            .Debug, .ReleaseSafe,
            => false,

            .ReleaseSmall, .ReleaseFast,
            => true,
        };
    };

    const stack_protector: bool = determine: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Determining <{s}> policy...",
            .{"stack_protector"});

        break :determine switch (opts.optimizemode) {
            .Debug,
            => false,

            .ReleaseSafe, .ReleaseSmall, .ReleaseFast,
            => true,
        };
    };

    const stack_check: bool = determine: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Determining <{s}> policy...",
            .{"stack_check"});

        break :determine switch (opts.optimizemode) {
            .Debug, .ReleaseSafe,
            => false,

            .ReleaseSmall, .ReleaseFast,
            => true,
        };
    };

    const valgrind: bool = determine: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Determining <{s}> policy...",
            .{"valgrind"});

        break :determine switch (opts.optimizemode) {
            .Debug, .ReleaseSafe,
            => true,

            .ReleaseSmall, .ReleaseFast,
            => false,
        };
    };

    const omit_frame_pointer: bool = determine: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Determining <{s}> policy...",
            .{"omit_frame_pointer"});

        break :determine switch (opts.optimizemode) {
            .Debug, .ReleaseSafe,
            => true,

            .ReleaseSmall, .ReleaseFast,
            => false,
        };
    };

    const force_llvm: bool = determine: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Determining <{s}> policy...",
            .{"force_llvm"});

        break :determine switch (opts.optimizemode) {
            .Debug, .ReleaseSafe,
            => false,

            .ReleaseSmall, .ReleaseFast,
            => true,
        };
    };

    const force_lld: bool = determine: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Determining <{s}> policy...",
            .{"force_lld"});

        break :determine switch (opts.optimizemode) {
            .Debug, .ReleaseSafe,
            => false,

            .ReleaseSmall, .ReleaseFast,
            => true,
        };
    };

    return .{
        .strip = strip,
        .stack_protector = stack_protector,
        .stack_check = stack_check,
        .valgrind = valgrind,
        .omit_frame_pointer = omit_frame_pointer,
        .force_llvm = force_llvm,
        .force_lld = force_lld
    };
}

pub fn toBuildStepOptions(self: CompilePolicy, b: *Build) *Build.Step.Options
{
    const opts = b.addOptions();

    opts.addOption(bool, "has_strip", self.strip);
    opts.addOption(bool, "has_stack_protector", self.stack_protector);
    opts.addOption(bool, "has_stack_check", self.stack_check);
    opts.addOption(bool, "has_valgrind", self.valgrind);
    opts.addOption(bool, "has_omit_frame_pointer", self.omit_frame_pointer);
    opts.addOption(bool, "has_force_llvm", self.force_llvm);
    opts.addOption(bool, "has_force_lld", self.force_lld);

    return opts;
}

pub inline fn displayDebug(self: CompilePolicy) void
{
    debug.print(
        \\           ::CompilePolicy::
        \\  ================================
        \\    strip:                {any}
        \\    stack_protector:      {any}
        \\    stack_check:          {any}
        \\    valgrind:             {any}
        \\    omit_frame_pointer:   {any}
        \\    force_llvm:           {any}
        \\    force_lld:            {any}
        \\  ================================
        \\
    , .{
        self.strip,
        self.stack_protector,
        self.stack_check,
        self.valgrind,
        self.omit_frame_pointer,
        self.force_llvm,
        self.force_lld,
    });
}

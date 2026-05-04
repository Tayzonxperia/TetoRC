// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC compilation policy options that are decided from a CompileOptions struct
const CompilePolicy = @This();

const std = @import("std");
const Build = std.Build;
const debug = std.debug;

const CompileOptions = @import("CompileOptions.zig");



strip:              bool,
stack_protector:     bool,
stack_check:         bool,
valgrind:           bool,
omit_frame_pointer:   bool,


pub fn fromCompileOptions(opts: CompileOptions) CompilePolicy
{
    return .{
        .strip = switch (opts.optimizemode) {
            .Debug, .ReleaseSafe,
            => false,

            .ReleaseSmall, .ReleaseFast,
            => true,
        },

        .stack_protector = switch (opts.optimizemode) {
            .Debug,
            => false,

            .ReleaseSafe, .ReleaseSmall, .ReleaseFast,
            => true,
        },

        .stack_check = switch (opts.optimizemode) {
            .Debug, .ReleaseSafe,
            => true,

            .ReleaseSmall, .ReleaseFast,
            => false,
        },

        .valgrind = if (opts.abi.isGnu())
            switch (opts.optimizemode) {
                .Debug, .ReleaseSafe,
                => true,

                .ReleaseSmall, .ReleaseFast,
                => false,
            }
        else
            false,

        .omit_frame_pointer = switch (opts.optimizemode) {
            .Debug, .ReleaseSafe,
            => false,

            .ReleaseSmall, .ReleaseFast,
            => true,
        }
    };
}

pub fn toBuildStepOptions(self: *CompilePolicy, b: *Build) *Build.Step.Options
{
    const opts = b.addOptions();

    opts.addOption(bool, "has_strip", self.strip);
    opts.addOption(bool, "has_stackprotector", self.stack_protector);
    opts.addOption(bool, "has_stackcheck", self.stack_check);
    opts.addOption(bool, "has_valgrind", self.valgrind);
    opts.addOption(bool, "has_omitframepointer", self.omit_frame_pointer);

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
        \\  ================================
        \\
    , .{
        self.strip,
        self.stack_protector,
        self.stack_check,
        self.valgrind,
        self.omit_frame_pointer,
    });
}

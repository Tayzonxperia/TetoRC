// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC compilation policy options that are decided from a CompileOptions struct
const CompilePolicy = @This();

const std = @import("std");
const Build = std.Build;
const debug = std.debug;

const CompileOptions = @import("CompileOptions.zig");



strip:              bool,
stackprotector:     bool,
stackcheck:         bool,
valgrind:           bool,
omitframepointer:   bool,


pub fn fromCompileOptions(opts: CompileOptions) CompilePolicy
{
    return .{
        .strip = switch (opts.optimizemode) {
            .Debug, .ReleaseSafe,
            => false,

            .ReleaseSmall, .ReleaseFast,
            => true,
        },

        .stackprotector = switch (opts.optimizemode) {
            .Debug,
            => false,

            .ReleaseSafe, .ReleaseSmall, .ReleaseFast,
            => true,
        },

        .stackcheck = switch (opts.optimizemode) {
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

        .omitframepointer = switch (opts.optimizemode) {
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
    opts.addOption(bool, "has_stackprotector", self.stackprotector);
    opts.addOption(bool, "has_stackcheck", self.stackcheck);
    opts.addOption(bool, "has_valgrind", self.valgrind);
    opts.addOption(bool, "has_omitframepointer", self.omitframepointer);

    return opts;
}

pub inline fn displayDebug(self: CompilePolicy) void
{
    debug.print(
        \\         ::CompilePolicy::
        \\  ==============================
        \\    strip:              {any}
        \\    stackprotector:     {any}
        \\    stackcheck:         {any}
        \\    valgrind:           {any}
        \\    omitframepointer:   {any}
        \\  ==============================
        \\
    , .{
        self.strip,
        self.stackprotector,
        self.stackcheck,
        self.valgrind,
        self.omitframepointer,
    });
}

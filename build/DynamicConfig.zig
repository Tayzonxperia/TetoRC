// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! # TetoRC build system dynamic configuration system.
const DynamicConfig = @This();

const std = @import("std");
const Build = std.Build;
const Target = std.Target;

const StaticConfig = @import("StaticConfig.zig");



resolved_target:    Build.ResolvedTarget,
strip:              bool,
stack_protector:    bool,
stack_check:        bool,
valgrind:           bool,
omit_frame_pointer: bool,
force_llvm:         bool,
force_lld:          bool,


pub fn init(static_config: StaticConfig, b: *Build) DynamicConfig
{
    return .{
        .resolved_target = create: {
            break :create b.resolveTargetQuery(.{
                .cpu_arch = static_config.compilation_flags.cpu_arch,
                .os_tag = static_config.compilation_flags.os_tag,
                .abi = static_config.compilation_flags.abi,
            });
        },

        .strip = create: {
            break :create switch (static_config.compilation_flags.optimizemode) {
                .Debug, .ReleaseSafe        => false,
                .ReleaseSmall, .ReleaseFast => true,
            };
        },

        .stack_protector = create: {
            break :create switch (static_config.compilation_flags.optimizemode) {
                .Debug                                      => false,
                .ReleaseSafe, .ReleaseSmall, .ReleaseFast   => true,
            };
        },

        .stack_check = create: {
            break :create switch (static_config.compilation_flags.optimizemode) {
                .Debug                                      => false,
                .ReleaseSafe, .ReleaseSmall, .ReleaseFast   => true,
            };
        },

        .valgrind = create: {
            break :create switch (static_config.compilation_flags.optimizemode) {
                .Debug, .ReleaseSafe        => true,
                .ReleaseSmall, .ReleaseFast => false,
            };
        },

        .omit_frame_pointer = create: {
            break :create switch (static_config.compilation_flags.optimizemode) {
                .Debug, .ReleaseSafe        => false,
                .ReleaseSmall, .ReleaseFast => true,
            };
        },

        .force_llvm = create: {
            break :create switch (static_config.compilation_flags.optimizemode) {
                .Debug                                      => false,
                .ReleaseSafe, .ReleaseSmall, .ReleaseFast   => true,
            };
        },

        .force_lld = create: {
            break :create switch (static_config.compilation_flags.optimizemode) {
                .Debug                                      => false,
                .ReleaseSafe, .ReleaseSmall, .ReleaseFast   => true,
            };
        },
    };
}

pub fn toOptions(self: DynamicConfig, b: *Build) *Build.Step.Options
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

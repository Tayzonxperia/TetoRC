// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! # TetoRC build system static configuration system.
const StaticConfig = @This();

const std = @import("std");
const builtin = std.builtin;
const Build = std.Build;
const Target = std.Target;



compilation_flags:  CompilationFlags,
feature_flags:      FeatureFlags,
build_preset:       ?BuildPreset = null,


/// `MacBackend`
///
/// Which Mandatory Access Control system backend
/// do we have support for.
const MacBackend = enum
{
    none,
    selinux,
    smack,

    pub fn toSlice(self: @This()) []const u8 {
        comptime return switch (self) {
            .none       => "MacBackend:none",
            .selinux    => "MacBackend:selinux",
            .smack      => "MacBackend:smack",
        };
    }
};

/// `CompressBackend`
///
/// Which compression algorithm backend do we
/// have support for.
const CompressBackend = enum
{
    none,
    flate,
    lzma2,
    zstd,

    pub fn toSlice(self: @This()) []const u8 {
        comptime return switch (self) {
            .none       => "CompressBackend:none",
            .flate      => "CompressBackend:flate",
            .lzma2      => "CompressBackend:lzma2",
            .zstd       => "CompressBackend:zstd",
        };
    }
};

/// `CompilationFlags`
///
/// Values that affect how the build system will compile
/// and link the binary artifacts, such as optimization
/// mode or target triple.
pub const CompilationFlags = struct
{
    optimizemode:   builtin.OptimizeMode,
    linkmode:       builtin.LinkMode,
    codemodel:      builtin.CodeModel,
    cpu_arch:       Target.Cpu.Arch,
    os_tag:         Target.Os.Tag,
    abi:            Target.Abi,

    pub fn init(b: *Build) @This() {
        return .{
            .optimizemode = create: {
                break :create b.option(
                    builtin.OptimizeMode,
                    "optimizemode",
                    "TetoRC CompilationFlags: optimizemode") orelse .Debug;
            },

            .linkmode = create: {
                break :create b.option(
                    builtin.LinkMode,
                    "linkmode",
                    "TetoRC CompilationFlags: linkmode") orelse .dynamic;
            },

            .codemodel = create: {
                break :create b.option(
                    builtin.CodeModel,
                    "codemodel",
                    "TetoRC CompilationFlags: codemodel") orelse .default;
            },

            .cpu_arch = create: {
                break :create b.option(
                    Target.Cpu.Arch,
                    "cpu_arch",
                    "TetoRC CompilationFlags: cpu_arch") orelse .x86_64;
            },

            .os_tag = create: {
                break :create b.option(
                    Target.Os.Tag,
                    "os_tag",
                    "TetoRC CompilationFlags: os_tag") orelse .linux;
            },

            .abi = create: {
                break :create b.option(
                    Target.Abi,
                    "abi",
                    "TetoRC CompilationFlags: abi") orelse .gnu;
            },
        };
    }
};

/// `FeatureFlags`
///
/// Values that toggle features that will get compiled
/// into the binary artifacts, such as threading mode.
pub const FeatureFlags = struct
{
    mac_backend:        MacBackend,
    compress_backend:   CompressBackend,

    pub fn init(b: *Build) @This() {
        return .{
            .mac_backend = create: {
                break :create b.option(
                    MacBackend,
                    "mac_backend",
                    "TetoRC FeatureFlags: mac_backend") orelse .none;   // TODO: Impl this
            },

            .compress_backend = create: {
                break :create b.option(
                    CompressBackend,
                    "compress_backend",
                    "TetoRC FeatureFlags: compress_backend") orelse .none;  // TODO: Impl this
            },
        };
    }
};

/// `BuildPreset`
///
/// Enumeration value that will pre-apply flags
/// depending on the set value. Will patch on-top
/// of a existing `StaticConfig`.
pub const BuildPreset = enum
{
    embedded,
    desktop,
    server,

    pub fn init(b: *Build) @This() {
        return b.option(
            @This(),
            "build_preset",
            "TetoRC BuildPreset") orelse .desktop;
    }

    pub fn apply(self: @This(), base: StaticConfig) StaticConfig {
        return switch (self) {
            .embedded => .{
                .compilation_flags = .{
                    .optimizemode = .ReleaseSmall,
                    .linkmode = .static,
                    .codemodel = .small,
                    .cpu_arch = base.compilation_flags.cpu_arch,
                    .os_tag = base.compilation_flags.os_tag,
                    .abi = base.compilation_flags.abi,
                },

                .feature_flags = .{
                    .mac_backend = .none,
                    .compress_backend = .lzma2,
                },

                .build_preset = self,
            },

            .desktop => .{
                .compilation_flags = .{
                    .optimizemode = .ReleaseSafe,
                    .linkmode = .dynamic,
                    .codemodel = .default,
                    .cpu_arch = base.compilation_flags.cpu_arch,
                    .os_tag = base.compilation_flags.os_tag,
                    .abi = base.compilation_flags.abi,
                },

                .feature_flags = .{
                    .mac_backend = .none,
                    .compress_backend = .flate,
                },

                .build_preset = self,
            },

            .server => .{
                .compilation_flags = .{
                    .optimizemode = .ReleaseFast,
                    .linkmode = .dynamic,
                    .codemodel = .default,
                    .cpu_arch = base.compilation_flags.cpu_arch,
                    .os_tag = base.compilation_flags.os_tag,
                    .abi = base.compilation_flags.abi,
                },

                .feature_flags = .{
                    .mac_backend = .selinux,
                    .compress_backend = .zstd,
                },

                .build_preset = self,
            },
        };
    }
};

pub fn toOptions(self: StaticConfig, b: *Build) *Build.Step.Options
{
    const opts = b.addOptions();

    opts.addOption(CompilationFlags, "COMPILATION_FLAGS", self.compilation_flags);
    opts.addOption(FeatureFlags, "FEATURE_FLAGS", self.feature_flags);
    opts.addOption(?BuildPreset, "BUILD_PRESET", self.build_preset);

    return opts;
}

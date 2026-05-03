// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC compilation options that can be altered to modify the resulting executables.
const CompileOptions = @This();

const std = @import("std");
const builtin = std.builtin;
const Build = std.Build;
const debug = std.debug;
const Target = std.Target;



optimizemode:   builtin.OptimizeMode,
linkmode:       builtin.LinkMode,
codemodel:      builtin.CodeModel,
cpu_arch:        Target.Cpu.Arch,
os_tag:          Target.Os.Tag,
abi:            Target.Abi,


pub fn fromBuild(b: *Build) CompileOptions
{
    return .{
        .optimizemode = b.option(
        builtin.OptimizeMode,
        "optimizemode",
        "TetoRC builtin optimize mode"
        ) orelse .Debug,

        .linkmode = b.option(
        builtin.LinkMode,
        "linkmode",
        "TetoRC builtin link mode"
        ) orelse .dynamic,

        .codemodel = b.option(
        builtin.CodeModel,
        "codemodel",
        "TetoRC builtin code model"
        ) orelse .default,

        .cpu_arch = b.option(
        Target.Cpu.Arch,
        "cpuarch",
        "TetoRC target CPU arch"
        ) orelse .x86_64,

        .os_tag = b.option(
        Target.Os.Tag,
        "ostag",
        "TetoRC target OS tag"
        ) orelse .linux,

        .abi =  b.option(
        Target.Abi,
        "abi",
        "TetoRC target ABI"
        ) orelse .gnu,
    };
}

pub fn toBuildStepOptions(self: *CompileOptions, b: *Build) *Build.Step.Options
{
    const opts = b.addOptions();

    opts.addOption(builtin.OptimizeMode, "builtin_OptimizeMode", self.optimizemode);
    opts.addOption(builtin.LinkMode, "builtin_LinkMode", self.linkmode);
    opts.addOption(builtin.CodeModel, "builtin_CodeModel", self.codemodel);
    opts.addOption(Target.Cpu.Arch, "Target_Cpu_Arch", self.cpu_arch);
    opts.addOption(Target.Os.Tag, "Target_Os_Tag", self.os_tag);
    opts.addOption(Target.Abi, "Target_Abi", self.abi);

    return opts;
}

pub inline fn displayDebug(self: CompileOptions) void
{
    debug.print(
        \\        ::CompileOptions::
        \\  ==============================
        \\     optimizemode:       {any}
        \\     linkmode:           {any}
        \\     codemodel:          {any}
        \\     cpu_arch:           {any}
        \\     os_tag:             {any}
        \\     abi:                {any}
        \\  ==============================
        \\
    , .{
        self.optimizemode,
        self.linkmode,
        self.codemodel,
        self.cpu_arch,
        self.os_tag,
        self.abi,
    });
}

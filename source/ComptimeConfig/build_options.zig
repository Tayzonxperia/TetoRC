// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
const std = @import("std");
const builtin = std.builtin;
const Target = std.Target;



/// Binary optimization mode
optimizemode:       builtin.OptimizeMode,
/// Binary linkage mode
linkmode:           builtin.LinkMode,
/// Binary code model
codemodel:          builtin.CodeModel,
/// Target CPU Architecture
cpu_arch:           Target.Cpu.Arch,
/// Target OS Tag
os_tag:             Target.Os.Tag,
/// Target ABI
abi:                Target.Abi,
/// Is the binary single threaded?
single_threaded:    bool,


pub fn init(
    optimizemode:       builtin.OptimizeMode,
    linkmode:           builtin.LinkMode,
    codemodel:          builtin.CodeModel,
    cpu_arch:           Target.Cpu.Arch,
    os_tag:             Target.Os.Tag,
    abi:                Target.Abi,
    single_threaded:    bool) @This()
{

    return .{
        .optimizemode = optimizemode,
        .linkmode = linkmode,
        .codemodel = codemodel,
        .cpu_arch = cpu_arch,
        .os_tag = os_tag,
        .abi = abi,
        .single_threaded = single_threaded,
    };
}

pub inline fn isProduction(self: @This()) bool
{
    comptime return switch (self.optimizemode) {
    .ReleaseFast, .ReleaseSmall => true,
    .ReleaseSafe, .Debug        => false
    };
}

pub inline fn isSingleThreaded(self: @This()) bool
{ comptime return self.single_threaded; }

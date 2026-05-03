// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC capability tags to determine whether a target is able to run TetoRC correctly
const TargetCapability = @This();

const std = @import("std");
const Build = std.Build;
const debug = std.debug;



overall_score:  Level,
cpu_score:      Level,
os_score:       Level,
abi_score:      Level,


/// **`Level`** - this value determines the support value of a section, of 1..3, where 1 is the lowest level and 3 is the highest level
///
/// - **min** -> TetoRC may not work for this target, or may be broken
///
/// - **mid** -> TetoRC has support, but may be buggy or preform worse on this target
///
/// - **max** -> TetoRC has full support for this target, it has been tested and will be the most stable
///
pub const Level = enum(u2)
{
    min = 1,
    mid = 2,
    max = 3,
};

pub fn fromResolvedTarget(tgt: Build.ResolvedTarget) TargetCapability
{
    const cpuSupport: Level = switch (tgt.result.cpu.arch) {
        .x86, .x86_64,
        .arm, .aarch64,
        => .max,

        .armeb, .aarch64_be,
        .riscv32, .riscv64,
        .riscv32be, .riscv64be,
        => .mid,

        else
        => .min
    };

    const osSupport: Level = switch (tgt.result.os.tag) {
        .linux,
        => .max,

        .freebsd,
        .openbsd,
        .netbsd,
        .dragonfly,
        => .mid,

        else
        => .min
    };

    const abiSupport: Level = if (tgt.result.abi.isGnu())
        .max
    else if (tgt.result.abi.isMusl())
        .mid
    else
        .min;


    return .{
        .overall_score = @enumFromInt(@min(
            @intFromEnum(cpuSupport),
            @intFromEnum(osSupport),
            @intFromEnum(abiSupport),
        )),
        .cpu_score = cpuSupport,
        .os_score = osSupport,
        .abi_score = abiSupport,
    };
}

pub inline fn displayDebug(self: TargetCapability) void
{
    debug.print(
        \\         ::TargetSupport::
        \\  ==============================
        \\    overall_score:  {d} [{any}]
        \\    cpu_score:      {d} [{any}]
        \\    os_score:       {d} [{any}]
        \\    abi_score:      {d} [{any}]
        \\  ==============================
        \\
    , .{
        self.overall_score, self.overall_score,

        self.cpu_score, self.cpu_score,
        self.os_score, self.os_score,
        self.abi_score, self.abi_score,
    });
}

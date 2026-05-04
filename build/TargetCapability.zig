// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC capability tags to determine whether a target is able to run TetoRC correctly
const TargetCapability = @This();

const std = @import("std");
const Build = std.Build;
const debug = std.debug;

const MessageLogger:    type = @import("MessageLogger.zig");



overall_score:  Level,
cpu_score:      Level,
os_score:       Level,
abi_score:      Level,


pub const Level = enum(u2)
{
    min = 1,
    mid = 2,
    max = 3,

    pub inline fn toInteger(comptime self: @This()) u8
    { return @intFromEnum(self); }
};

pub fn fromResolvedTarget(tgt: Build.ResolvedTarget) TargetCapability
{
    const cpuSupport: Level = determine: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Determining <{s}> capability score...",
            .{"cpuSupport"});

        const ret: Level = switch (tgt.result.cpu.arch) {
            .x86, .x86_64,
            .arm, .aarch64,
            => Level.max,

            .armeb, .aarch64_be,
            .riscv32, .riscv64,
            .riscv32be, .riscv64be,
            => Level.mid,

            else
            => Level.min
        };

        break :determine ret;
    };

    const osSupport: Level = determine: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Determining <{s}> capability score...",
            .{"osSupport"});

        const ret: Level = switch (tgt.result.os.tag) {
            .linux,
            => Level.max,

            .freebsd,
            .openbsd,
            .netbsd,
            .dragonfly,
            => Level.mid,

            else
            => Level.min
        };

        break :determine ret;
    };

    const abiSupport: Level = determine: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Determining <{s}> capability score...",
            .{"abiSupport"});

        const ret: Level = if (tgt.result.abi.isGnu())
            Level.max
        else if (tgt.result.abi.isMusl())
            Level.mid
        else
            Level.min;

        break :determine ret;
    };

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

pub fn checkScores(self: TargetCapability) void
{
    switch (self.overall_score) {
        .min    => MessageLogger.logMessage(
            MessageLogger.Level.warn,
            "Target unsupported! Expect compilation issues -> (overall_score: {d})"
            ,.{self.overall_score}),

        .mid    => MessageLogger.logMessage(
            MessageLogger.Level.warn,
            "Target untested! Expect runtime issues. (overall_score: {d})"
            ,.{self.overall_score}),

        .max    => MessageLogger.logMessage(
            MessageLogger.Level.okay,
            "Target supported! Expect clean compilation -> (overall_score: {d})"
            ,.{self.overall_score}),
    }
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

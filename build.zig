// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
const std = @import("std");
const Build = std.Build;

const CompileOptions = @import("build/CompileOptions.zig");
const CompilePolicy = @import("build/CompilePolicy.zig");
const TargetCapability = @import("build/TargetCapability.zig");

const BuildZigZon = @import("build.zig.zon");



/// The build.zig main function
/// that gets called when as soon
/// as `zig build` is executed
pub fn build(b: *Build) void
{
    const compileOptions: CompileOptions = .fromBuild(b);
    const compilePolicy: CompilePolicy = .fromCompileOptions(compileOptions);

    const resolvedTarget = b.resolveTargetQuery(.{
        .cpu_arch = compileOptions.cpuarch,
        .os_tag = compileOptions.ostag,
        .abi = compileOptions.abi,
    });

    const targetCapability: TargetCapability = .fromResolvedTarget(resolvedTarget);

    std.debug.print("\n", .{});
    compileOptions.displayDebug();
    std.debug.print("\n", .{});
    compilePolicy.displayDebug();
    std.debug.print("\n", .{});
    targetCapability.displayDebug();
    std.debug.print("\n", .{});

}

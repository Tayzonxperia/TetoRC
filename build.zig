// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
const std = @import("std");
const Build = std.Build;

const CompileOptions = @import("build/CompileOptions.zig");
const CompilePolicy = @import("build/CompilePolicy.zig");
const TargetCapability = @import("build/TargetCapability.zig");
const GitRepository = @import("build/GitRepository.zig");

const BuildZigZon = @import("build.zig.zon");



/// The build.zig main function
/// that gets called when as soon
/// as `zig build` is executed
pub fn build(b: *Build) void
{
    const compileOptions: CompileOptions = CompileOptions.fromBuild(b);
    const compilePolicy: CompilePolicy = CompilePolicy.fromCompileOptions(compileOptions);

    const resolvedTarget = b.resolveTargetQuery(.{
        .cpu_arch = compileOptions.cpu_arch,
        .os_tag = compileOptions.os_tag,
        .abi = compileOptions.abi,
    });

    const targetCapability: TargetCapability = TargetCapability.fromResolvedTarget(resolvedTarget);
    const gitRepository: GitRepository = GitRepository.fromBuild(b) catch unreachable;

    std.debug.print("\n", .{});
    compileOptions.displayDebug();
    std.debug.print("\n", .{});
    compilePolicy.displayDebug();
    std.debug.print("\n", .{});
    targetCapability.displayDebug();
    std.debug.print("\n", .{});
    gitRepository.displayDebug();
    std.debug.print("\n", .{});

}

// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
const std = @import("std");
const Build = std.Build;
const debug = std.debug;

const MessageLogger: type = @import("build/MessageLogger.zig");
const GitRepository = @import("build/GitRepository.zig");
const CompileOptions = @import("build/CompileOptions.zig");
const CompilePolicy = @import("build/CompilePolicy.zig");
const TargetCapability = @import("build/TargetCapability.zig");
const ModuleRegister = @import("build/ModuleRegister.zig");

const BuildZigZon = @import("build.zig.zon");



pub fn build(b: *Build) void
{
    const gitRepository: GitRepository = GitRepository.fromBuild(b) catch unreachable;

    const compileOptions: CompileOptions = CompileOptions.fromBuild(b);
    const compilePolicy: CompilePolicy = CompilePolicy.fromCompileOptions(compileOptions);
    const compileOptionsOpts: *Build.Step.Options = compileOptions.toBuildStepOptions(b);
    const compilePolicyOpts: *Build.Step.Options = compilePolicy.toBuildStepOptions(b);

    const resolvedTarget: Build.ResolvedTarget = b.resolveTargetQuery(.{
        .cpu_arch = compileOptions.cpu_arch,
        .os_tag = compileOptions.os_tag,
        .abi = compileOptions.abi,
    });

    const targetCapability: TargetCapability = TargetCapability.fromResolvedTarget(resolvedTarget);
    targetCapability.checkScores();

    const mod = ModuleRegister.add(
        "test",
        "source/main.zig",
        .{},
        compileOptions,
        compilePolicy,
        resolvedTarget,
        b);
}

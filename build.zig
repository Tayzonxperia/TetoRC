// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
const std = @import("std");
const Build = std.Build;

const StaticConfig = @import("build/StaticConfig.zig");
const DynamicConfig = @import("build/DynamicConfig.zig");
const BinaryMetadata = @import("build/BinaryMetadata.zig");
const ModuleFactory = @import("build/ModuleFactory.zig");


pub fn build(b: *Build) void
{
    const staticConfig: StaticConfig = .{
        .compilation_flags = .init(b),
        .feature_flags = .init(b),
        .build_preset = .init(b)
    };
    const staticOptions = staticConfig.toOptions(b);

    const dynamicConfig: DynamicConfig = DynamicConfig.init(staticConfig, b);
    const dynamicOptions = dynamicConfig.toOptions(b);

    const binaryMetadata: BinaryMetadata = BinaryMetadata.init(b);

    const staticModule = staticOptions.createModule();
    const dynamicModule = dynamicOptions.createModule();

    _ = staticModule;
    _ = dynamicModule;

    std.debug.print("{s}\n", .{binaryMetadata.version_data.string});
}

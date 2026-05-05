// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC compilation options that can be altered to modify the resulting executables.
const CompileOptions = @This();

const std = @import("std");
const builtin = std.builtin;
const Build = std.Build;
const debug = std.debug;
const Target = std.Target;

const MessageLogger = @import("MessageLogger.zig");



optimizemode:       builtin.OptimizeMode,
linkmode:           builtin.LinkMode,
codemodel:          builtin.CodeModel,
cpu_arch:           Target.Cpu.Arch,
os_tag:             Target.Os.Tag,
abi:                Target.Abi,
single_threaded:    bool,


pub fn fromBuild(b: *Build) CompileOptions
{
    const optimizemode = create: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Creating <{s}> build option...",
            .{"optimizemode"});

        break :create b.option(
            builtin.OptimizeMode,
            "optimizemode",
            "TetoRC builtin optimize mode",
        ) orelse .Debug;
    };

    const linkmode = create: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Creating <{s}> build option...",
            .{"linkmode"});

        break :create b.option(
            builtin.LinkMode,
            "linkmode",
            "TetoRC builtin link mode",
        ) orelse .dynamic;
    };

    const codemodel = create: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Creating <{s}> build option...",
            .{"codemodel"});

        break :create b.option(
            builtin.CodeModel,
            "codemodel",
            "TetoRC builtin code model"
        ) orelse .default;
    };

    const cpu_arch = create: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Creating <{s}> build option...",
            .{"cpu_arch"});

        break :create b.option(
            Target.Cpu.Arch,
            "cpu_arch",
            "TetoRC target CPU arch"
        ) orelse .x86_64;
    };

    const os_tag = create: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Creating <{s}> build option...",
            .{"os_tag"});

        break :create b.option(
            Target.Os.Tag,
            "os_tag",
            "TetoRC target OS tag"
        ) orelse .linux;
    };

    const abi = create: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Creating <{s}> build option...",
            .{"abi"});

        break :create b.option(
            Target.Abi,
            "abi",
            "TetoRC target ABI"
        ) orelse .gnu;
    };

    const single_threaded = create: {
        MessageLogger.logMessage(
            MessageLogger.Level.expr,
            "Creating <{s}> build option...",
            .{"single_threaded"});

        break :create b.option(
            bool,
            "single_threaded",
            "TetoRC threading type"
        ) orelse true;  // For now, needs impl
    };

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

pub fn toBuildStepOptions(self: *CompileOptions, b: *Build) *Build.Step.Options
{
    const opts = b.addOptions();

    opts.addOption(builtin.OptimizeMode, "builtin_OptimizeMode", self.optimizemode);
    opts.addOption(builtin.LinkMode, "builtin_LinkMode", self.linkmode);
    opts.addOption(builtin.CodeModel, "builtin_CodeModel", self.codemodel);
    opts.addOption(Target.Cpu.Arch, "Target_Cpu_Arch", self.cpu_arch);
    opts.addOption(Target.Os.Tag, "Target_Os_Tag", self.os_tag);
    opts.addOption(Target.Abi, "Target_Abi", self.abi);
    opts.addOption(bool, "is_single_threaded", self.single_threaded);

    return opts;
}

pub inline fn displayDebug(self: CompileOptions) void
{
    debug.print(
        \\        ::CompileOptions::
        \\  ===============================
        \\     optimizemode:        {any}
        \\     linkmode:            {any}
        \\     codemodel:           {any}
        \\     cpu_arch:            {any}
        \\     os_tag:              {any}
        \\     abi:                 {any}
        \\     single_threadedd:    {any}
        \\  ===============================
        \\
    , .{
        self.optimizemode,
        self.linkmode,
        self.codemodel,
        self.cpu_arch,
        self.os_tag,
        self.abi,
        self.single_threaded
    });
}

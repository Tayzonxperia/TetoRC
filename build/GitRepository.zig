// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC Git repository data and infomation gathered at compile time
const GitRepository = @This();

const std = @import("std");
const ascii = std.ascii;
const Build = std.Build;
const debug = std.debug;
const mem = std.mem;



short_hash: []const u8,
long_hash:  []const u8,
branch:     []const u8,
tag:        ?[]const u8,
is_dirty:   bool,


pub const Error = error
{
    GitNotFound,
    GitNotRepository
};

pub fn fromBuild(b: *Build) !GitRepository
{
    var exitCode: u8 = 0;

    const short_hash: []const u8 = execute: {
        const ret = b.runAllowFail(
            &[_][]const u8 { "git", "-C", b.build_root.path orelse ".", "rev-parse", "--short", "HEAD" },
            &exitCode,
            .ignore) catch |err| switch (err) {
                error.FileNotFound  => return Error.GitNotFound,
                else                => return err,
            };

        break :execute mem.trimEnd(u8, ret, "\r\n ");
    };

    const long_hash: []const u8 = execute: {
        const ret = b.runAllowFail(
            &[_][]const u8 { "git", "-C", b.build_root.path orelse ".", "rev-parse", "HEAD" },
            &exitCode,
            .ignore) catch |err| switch (err) {
                error.FileNotFound  => return Error.GitNotFound,
                else                => return err,
            };

        break :execute mem.trimEnd(u8, ret, "\r\n ");
    };

    const branch: []const u8 = execute: {
        const ret = b.runAllowFail(
            &[_][]const u8 { "git", "-C", b.build_root.path orelse ".", "rev-parse", "--abbrev-ref", "HEAD" },
            &exitCode,
            .ignore) catch |err| switch (err) {
                error.FileNotFound      => return error.GitNotFound,
                error.ExitCodeFailure   => return error.GitNotRepository,
                else                    => return err,
        };

        for (ret) |*char| {
            if (!ascii.isAlphanumeric(char.*) and char.* != '-') char.* = '-';
        }

        break :execute mem.trimEnd(u8, ret, "-\r\n ");
    };

    const tag: ?[]const u8 = execute: {
        const ret = b.runAllowFail(
            &[_][]const u8 { "git", "-C", b.build_root.path orelse ".", "describe", "--exact-match", "--tags" },
            &exitCode,
            .ignore) catch |err| switch (err) {
                error.FileNotFound      => return error.GitNotFound,
                error.ExitCodeFailure   => break :execute null, // Expected behavior
                else                    => return err,
            };

        break :execute mem.trimEnd(u8, ret, "\r\n ");
    };

    _ = b.runAllowFail(
            &[_][]const u8 { "git", "-C", b.build_root.path orelse ".", "diff", "--quiet", "--exit-code" },
            &exitCode,
            .ignore) catch |err| switch (err) {
                error.FileNotFound      => return error.GitNotFound,
                error.ExitCodeFailure   => {},  // Expected behavior
                else                    => return err,
            };

    const is_dirty = exitCode != 0;

    return .{
        .short_hash = short_hash,
        .long_hash = long_hash,
        .branch = branch,
        .tag = tag,
        .is_dirty = is_dirty,
    };
}

pub inline fn displayDebug(self: GitRepository) void
{
    debug.print(
        \\        ::GitRepository::
        \\  =============================
        \\      short_hash: {s}
        \\      long_hash:  {s}
        \\      branch:     {s}
        \\      tag:        {s}
        \\      is_dirty:   {any}
        \\  =============================
        \\
    , .{
        self.short_hash,
        self.long_hash,
        self.branch,
        self.tag orelse "<missing>",
        self.is_dirty,
    });
}

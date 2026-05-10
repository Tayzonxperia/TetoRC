// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! # TetoRC build system binary metadata embedder.
const BinaryMetadata = @This();

const std = @import("std");
const ascii = std.ascii;
const Build = std.Build;
const mem = std.mem;
const SemanticVersion = std.SemanticVersion;



git_info:       ?GitInfo,
version_data:   VersionData,


const GitInfo = struct
{
    short_hash: []const u8,
    long_hash:  []const u8,
    branch:     []const u8,
    tag:        ?[]const u8,
    is_dirty:   bool,

    const Error = error {
        GitNotFound,
        GitNotRepository,
    };

    fn init(b: *Build) !GitInfo {
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
};

const VersionData = struct
{
    string: []const u8,
    
    pub fn init(git_info: GitInfo, b: *Build) @This() {
        const scriptPath = clean: {
            const trimmed = mem.trimEnd(u8, b.build_root.path orelse ".", " \r\n");
            break :clean mem.concat(b.allocator, u8, &[_][]const u8 { trimmed, "/tools/provide_version.bash"}) catch unreachable;
        };

        const versionStr = obtain: {
            const raw = b.run(&[_][]const u8 {"bash", scriptPath});
            break :obtain mem.trimEnd(u8, raw, " \r\n");
        };

        return .{
            .string = merge: {
                break :merge mem.concat(
                    b.allocator,
                    u8,
                    &[_][]const u8 { versionStr, "+git", git_info.short_hash}) catch unreachable;
            },
        };
    }
};

pub fn init(b: *Build) BinaryMetadata
{
    const gitInfo = GitInfo.init(b) catch unreachable;

    return .{
        .git_info = gitInfo,
        .version_data = VersionData.init(gitInfo, b),
    };
}


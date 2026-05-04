// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC build system message logger and debugger. Uses `std.debug.print` as
//! anything more complex is not needed. Uses color codes.
const MessageLogger = @This();

const std = @import("std");
const debug = std.debug;



const ColorCode = struct
{
    code: [:0]const u8,

    inline fn fromSlice(comptime N: []const u8) @This()
    { comptime return .{ .code = "\x1b[" ++ N ++ "m" }; }

    inline fn toSlice(comptime self: @This()) [:0]const u8
    { comptime return self.code; }
};

const RESET_CODE:   ColorCode = ColorCode.fromSlice("0");
const RED_CODE:     ColorCode = ColorCode.fromSlice("31");
const GREEN_CODE:   ColorCode = ColorCode.fromSlice("32");
const YELLOW_CODE:  ColorCode = ColorCode.fromSlice("33");
const CYAN_CODE:    ColorCode = ColorCode.fromSlice("36");

pub const Level = enum(u4)
{
    expr = 0,
    okay = 1,
    warn = 2,
    fail = 3,
    _
};

pub fn logMessage(comptime L: Level, comptime fmt: []const u8, args: anytype) void
{
    switch (L) {
        .expr   => debug.print("[:: " ++ CYAN_CODE.toSlice() ++ "EXPR" ++ RESET_CODE.toSlice() ++ " ::] " ++ fmt ++ "\n", args),
        .okay   => debug.print("[:: " ++ GREEN_CODE.toSlice() ++ "OKAY" ++ RESET_CODE.toSlice() ++ " ::] " ++ fmt ++ "\n", args),
        .warn   => debug.print("[:: " ++ YELLOW_CODE.toSlice() ++ "WARN" ++ RESET_CODE.toSlice() ++ " ::] " ++ fmt ++ "\n", args),
        .fail   => debug.print("[:: " ++ RED_CODE.toSlice() ++ "FAIL" ++ RESET_CODE.toSlice() ++ " ::] " ++ fmt ++ "\n", args),
        _       => return,
    }
}

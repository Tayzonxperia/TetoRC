// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC stage 0 - initramfs bootstrapper
const std = @import("std");
const debug = std.debug;
const Io = std.Io;
const process = std.process;

const ctcfg = @import("ComptimeConfig");



pub fn main(init: process.Init) void
{
    _ = init;
    debug.print("Hello {s} \n", .{"s"});
}

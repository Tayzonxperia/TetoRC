// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)



/// Is the binary stripped of debug infomation?
strip:              bool,
/// Does the binary have a stack protector?
stack_protector:    bool,
/// Does the binary have stack checking?
stack_check:        bool,
/// Does the binary have Valgrind support?
valgrind:           bool,
/// Does the frame pointer exist?
omit_frame_pointer: bool,
/// Compiled with LLVM forced?
force_llvm:         bool,
/// Compiled with LLD forced?
force_lld:          bool,


pub fn init(
    strip:              bool,
    stack_protector:    bool,
    stack_check:        bool,
    valgrind:           bool,
    omit_frame_pointer: bool,
    force_llvm:         bool,
    force_lld:          bool) @This()
{

    return .{
        .strip = strip,
        .stack_protector = stack_protector,
        .stack_check = stack_check,
        .valgrind = valgrind,
        .omit_frame_pointer = omit_frame_pointer,
        .force_llvm = force_llvm,
        .force_lld = force_lld,
    };
}

pub inline fn isStripped(self: @This()) bool
{ comptime return self.strip; }

pub inline fn llvmWasForced(self: @This()) bool
{ comptime return self.force_llvm or self.force_lld; }

pub inline fn isStackSafe(self: @This()) bool
{ comptime return self.stack_protector and self.stack_check; }

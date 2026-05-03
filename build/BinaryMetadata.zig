// SPDX-License-Identifier: GPL-3.0-only
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
//! TetoRC binary metadata embedding and parsing, metadata will be embedded into
//! any executables and libraries produced, and can be used at runtime.
const BinaryMetadata = @This();

const std = @import("std");
const builtin = std.builtin;
const Build = std.Build;
const debug = std.debug;
const SemanticVersion = std.SemanticVersion;




pub const Version = struct
{

};



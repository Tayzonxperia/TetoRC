#!/bin/sh

#TetoRC installer script
#Installs TetoRC binaries and modules to system directories
#SPDX-License-Identifier: GPL-2.0-only

set -eu

#--- PATH CONFIGURATION ---

BIN_DIR="$(pwd)"
MOD_DIR="$(dirname "$(pwd)")/modules"

PREFIX="/mnt/lfs"
DEST_SBIN="${PREFIX}/sbin"
DEST_ETC="${PREFIX}/etc/tetorc"
DEST_RUN="${PREFIX}/run/tetorc"
DEST_LIB="${PREFIX}/usr/lib/tetorc"
DEST_LIBEXEC="${PREFIX}/usr/libexec/tetorc/modules"

#--- LOGGING HELPERS ---

info() { printf "[ INFO ] %s\n" "$1"; }
task() { printf "[ TASK ] %s\n" "$1"; }
warn() { printf "[ WARN ] %s\n" "$1" >&2; }
fail() { printf "[ FAIL ] %s\n" "$1" >&2; exit 1; }

#--- ROOT CHECK ---

[ "$(id -u)" -eq 0 ] || fail "This script must be run as root."

#--- SOURCE CHECKS ---

[ -f "${BIN_DIR}/tetorc-stage1" ] || fail "Missing binary: tetorc-stage1"
[ -f "${BIN_DIR}/tetorc-stage2" ] || fail "Missing binary: tetorc-stage2"
[ -d "${MOD_DIR}" ] || warn "Modules directory not found: ${MOD_DIR}"

info "Starting TetoRC installation"

#--- CREATE DIRECTORIES ---

task "Creating directories"
mkdir -p "$DEST_ETC" "$DEST_RUN" "$DEST_LIB" "$DEST_LIBEXEC"

#--- INSTALL BINARIES ---

task "Installing binaries"
for BIN in tetorc-stage1 tetorc-stage2; do
    info "./$BIN -> $DEST_SBIN/$BIN"
    install -m 755 "${BIN_DIR}/$BIN" "$DEST_SBIN/$BIN" || fail "Failed to copy binaries"
done

#--- INSTALL MODULES (if present) ---

if [ -d "$MOD_DIR" ]; then
task "Installing modules from ${MOD_DIR}"
cp -r "${MOD_DIR}/." "$DEST_LIBEXEC/" 2>/dev/null || fail "Failed to copy modules"
else
warn "Skipping module installation (none found)"
fi

#--- LINK INIT ---

if [ ! -L "/sbin/init" ]; then
task "Linking /sbin/init → tetorc-stage1"
ln -sv "$DEST_SBIN/tetorc-stage1" ${PREFIX}/sbin/init
else
CURRENT_TARGET="$(readlink ${PREFIX}/sbin/init || true)"
if [ "$CURRENT_TARGET" != "$DEST_SBIN/tetorc-stage1" ]; then
warn "/sbin/init currently links to: $CURRENT_TARGET"
warn "Use 'ln -svf $DEST_SBIN/tetorc-stage1 /sbin/init' manually if you wish to override."
fi
fi

#--- PERMISSIONS ---

task "Adjusting permissions"
chmod 755 "$DEST_SBIN/tetorc-stage1" "$DEST_SBIN/tetorc-stage2"

#--- DONE ---

info "TetoRC installation completed successfully!"
info "Directories prepared:"
printf " %s\n" "$DEST_ETC" "$DEST_RUN" "$DEST_LIB" "$DEST_LIBEXEC"
echo
info "Configure TetoRC in: /etc/tetorc/"
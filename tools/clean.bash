#!/usr/bin/env bash
set -euo pipefail



cleanDirectory()
{
    local dir="$1"

    if [ -d "${dir}" ]; then
        echo "Cleaning ${dir}"
        rm -rf "${dir}"
    else
        echo "Skipping ${dir}"
    fi
}

cleanDirectory .zig-cache
cleanDirectory nimcache

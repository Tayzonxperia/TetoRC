#!/bin/bash
# hasher for tetorc

if command -v b3sum >/dev/null; then
    HASHER="b3sum"
elif command -v sha512sum >/dev/null; then
    HASHER="sha512sum"
elif command -v b2sum >/dev/null; then
    HASHER="b2sum"
else
    HASHER="sha256sum"
fi

HASH=$(head -c 256 /dev/random | $HASHER | cut -d' ' -f1)

echo "hasher=$HASHER"
echo "hash=$HASH"
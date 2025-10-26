#!/bin/bash

CFLAGS="-O2 -pipe -ffreestanding -s"
DEBUG_CFLAGS="-g -O0 -pipe -ffreestanding"
OPT_CFLAGS="-march=native -mtune=native -O3 -flto -pipe -fno-exceptions -fno-rtti -fdata-sections -ffunction-sections -ffreestanding -s"
SMALL_CFLAGS="-Os -flto -pipe -s"

TETORC_S1="$(pwd)/../stage1/core/main.nim"
TETORC_S2="$(pwd)/../stage2/core/main.nim"

echo "[ INFO ] How would you like to build TetoRC?"
read -p "[ PROMPT ] Build Stage 1, Stage 2, or both? (1/2/both): " STAGE
STAGE=${STAGE,,} # lowercase it

if [ -z "$STAGE" ]; then STAGE="2"; fi

read -p "[ PROMPT ] Any defines? (e.g. -d:debug) " DEFINE
if [ -z "$DEFINE" ]; then DEFINE="-d:null"; fi
echo "[ INFO ] You have defined '$DEFINE'"

read -p "[ PROMPT ] Verbosity level (0–3): " VERB
VERB=${VERB:-1}
echo "[ INFO ] Compiler verbosity set to $VERB"
VERB="--verbosity:$VERB"

echo "Available compile presets:"
echo "1) Default"
echo "2) Debug"
echo "3) Optimized"
echo "4) Tiny"
read -p "[ PROMPT ] Select preset: " ANS

# --- Build function ---
build() {
    local SRC="$1"
    local OUT="$2"
    echo "[ BUILD ] Compiling $OUT..."
    time nim c -f $DEFINE_FLAGS "$DEFINE" "$VERB" \
        --passC:"$CSET" --passL:"$CSET" \
        -o:"$OUT" "$SRC" \
        && echo "[ OK ] $OUT compiled successfully!" \
        || { echo "[ ERROR ] Failed to build $OUT"; exit 1; }
}

# --- Select compile flags based on preset ---
case "$ANS" in
1) CSET="$CFLAGS" DEFINE_FLAGS="-d:release -d:strip --threads:on --opt:speed --app:console" ;;
2) CSET="$DEBUG_CFLAGS" DEFINE_FLAGS="-d:debug --app:console" ;; 
3) CSET="$OPT_CFLAGS" DEFINE_FLAGS="-d:release -d:optimized -d:strip --threads:on --opt:speed --app:console" ;; 
4) CSET="$SMALL_CFLAGS" DEFINE_FLAGS="-d:release -d:tiny -d:strip --threads:on --opt:size --app:console" ;;
*) echo "[ ERROR ] Invalid preset!"; exit 1 ;;
esac

# --- Execute builds ---
case "$STAGE" in
1)
    build "$TETORC_S1" "tetorc-stage1" 
    ;;
2)
    build "$TETORC_S2" "tetorc-stage2" 
    ;;
both)
    build "$TETORC_S1" "tetorc-stage1" 
    build "$TETORC_S2" "tetorc-stage2" 
    ;;
*)
    echo "[ ERROR ] Invalid stage option!"
    exit 1
    ;;
esac

echo "[ INFO ] Build process completed."

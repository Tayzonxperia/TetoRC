#!/bin/bash

CFLAGS="-O2 -pipe -ffreestanding -s"
DEBUG_CFLAGS="-g -O0 -pipe -ffreestanding"
OPT_CFLAGS="-march=native -mtune=native -O3 -flto -pipe -fno-exceptions -fno-rtti -fdata-sections -ffunction-sections -ffreestanding -s"
SMALL_CFLAGS="-march=native -mtune=native -Os -flto -pipe -s"

TETORC_S0="$(pwd)/../stage0/core/main.nim"
TETORC_S1="$(pwd)/../stage1/core/main.nim"
TETORC_S2="$(pwd)/../stage2/core/main.nim"

echo "[ INFO ] How would you like to build TetoRC?"
read -p "[ PROMPT ] Build Stage 0, 1, 2 or all stages? (0/1/2/all): " STAGE
STAGE=${STAGE,,} # lowercase it
if [ -z "$STAGE" ]; then STAGE="1"; fi

read -p "[ PROMPT ] Build static or shared? " LIBSTATE
if [ -z "$LIBSTATE" ]; then LIBSTATE="-d:shared"; LIBSET=" --shared"; fi
if [[ "$LIBSTATE" == "static" ]]; then
    LIBSTATE="-d:static"
    LIBSET=" --static"
elif [[ "$LIBSTATE" == "shared" ]]; then
    LIBSTATE="-d:shared"
    LIBSET=" --shared"
fi

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
echo ""

# --- Test function ---
test() {
    local TESTING="$1"
    echo "[ TEST ] Testing for $TESTING..."
    
    TESTLOC=$(which "$TESTING") && echo "[ TEST ] $TESTING found at $TESTLOC"

    if [[ "$TESTING" == "gcc" || "$TESTING" == "nim" || "$TESTING" == "lua" || "$TESTING" == "python" ]]; then
        echo "[ TEST ] Preforming compiler check for $TESTING..."
        if ./Tests/check.sh "$TESTING"; then
            echo "[ OK ] $TESTING was validated successfully!"
            echo ""
        else
            echo "[ FAIL ] $TESTING was not validated successfully!"
            if [[ "$TESTING" == "gcc" || "$TESTING" == "nim" ]]; then
                echo "[ ERROR ] $TESTING is a core dependency! Canceling build..."
                exit 1
            fi
            echo ""
        fi

    else
        echo "[ TEST ] Unknown test target: $TESTING"
    fi
}

# --- Build function ---
build() {
    local SRC="$1"
    local OUT="$2"
    for dep in nim gcc lua python; do
        test "$dep"
    done
    echo ""
    echo "[ BUILD ] Compiling $OUT..."
    if [[ "$LIBSET" == " --static" ]]; then
        CSET+=$LIBSET
    fi
    time nim c -f $DEFINE_FLAGS $LIBSTATE "$DEFINE" "$VERB" \
        --passC:"$CSET" --passL:"$CSET" \
        -o:"$OUT" "$SRC" \
        && echo "[ OK ] $OUT compiled successfully!" \
        || { echo "[ ERROR ] Failed to build $OUT"; exit 1; }
}

# --- Select compile flags based on preset ---
case "$ANS" in
1) CSET="$CFLAGS" DEFINE_FLAGS="-d:release -d:strip --threads:on --opt:speed --app:console" ;;
2) CSET="$DEBUG_CFLAGS" DEFINE_FLAGS="-d:debug --app:console" ;; 
3) CSET="$OPT_CFLAGS" DEFINE_FLAGS="-d:release -d:danger -d:gcoff --mm:none -d:optimized -d:strip --threads:on --opt:speed --app:console" ;; 
4) CSET="$SMALL_CFLAGS" DEFINE_FLAGS="-d:release -d:danger -d:gcoff --mm:none -d:tiny -d:strip --threads:on --opt:size --app:console" ;;
*) echo "[ ERROR ] Invalid preset!"; exit 1 ;;
esac

# --- Execute builds ---
case "$STAGE" in
0)
	build "$TETORC_S0" "tetorc-stage0"
	;;
1)
    build "$TETORC_S1" "tetorc-stage1" 
    ;;
2)
    build "$TETORC_S2" "tetorc-stage2" 
    ;;
all)
	build "$TETORC_S0" "tetorc-stage0"
    build "$TETORC_S1" "tetorc-stage1" 
    build "$TETORC_S2" "tetorc-stage2" 
    ;;
*)
    echo "[ ERROR ] Invalid stage option!"
    exit 1
    ;;
esac

echo "[ INFO ] Build process completed."

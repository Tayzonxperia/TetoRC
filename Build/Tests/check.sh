#!/bin/bash

check_languages() {
    TMPDIR=$(mktemp -d)
    echo "[ TEST ] Starting language sanity check in $TMPDIR"
    local ARG="$1"

    # --- C Test ---
    if [[ "$ARG" == "gcc" || "$ARG" == "cc" || "$ARG" == "c" ]]; then
        echo '[ TEST ] Checking C...'
        cat > "$TMPDIR/test.c" <<'EOF'
#include <stdio.h>
int main(void) { printf("C is working!\n"); return 0; }
EOF

        if gcc -o "$TMPDIR/test_c" "$TMPDIR/test.c" &>/dev/null && "$TMPDIR/test_c"; then
            echo "[ OK ] C checked successfully."
        else
            echo "[ FAIL ] C check failed!"
        fi
        echo ""

    # --- Nim Test ---
    elif [[ "$ARG" == "nim" ]]; then
        echo '[ TEST ] Checking Nim...'
        cat > "$TMPDIR/test.nim" <<'EOF'
echo "Nim is working!"
EOF

        if nim c -o="$TMPDIR/test_nim" "$TMPDIR/test.nim" &>/dev/null && "$TMPDIR/test_nim"; then
            echo "[ OK ] Nim checked successfully."
        else
            echo "[ FAIL ] Nim check failed!"
        fi
        echo ""

    # --- Lua Test ---
    elif [[ "$ARG" == "lua" || "$ARG" == "lament" ]]; then
        echo '[ TEST ] Checking Lua...'
        cat > "$TMPDIR/test.lua" <<'EOF'
print("Lua is working!")
EOF

        if command -v lua &>/dev/null && lua "$TMPDIR/test.lua"; then
            echo "[ OK ] Lua checked successfully."
        else
            echo "[ FAIL ] Lua check failed!"
        fi
        echo ""

	elif [[ "$ARG" == "python" || "$ARG" == "py" ]]; then
		echo '[ TEST ] Checking python...'
		cat > "$TMPDIR/test.py" << 'EOF'
print("Python is working!")
EOF

		if command -v python &>/dev/null && python "$TMPDIR/test.py"; then
			echo "[ OK ] Python checked successfully."
		else
			echo "[ FAIL ] Python check failed!"
		fi
		echo ""
		
    else
        echo "[ TEST ] Incorrect option: $ARG"
        exit 1
    fi

    rm -rf "$TMPDIR" && echo "[ TEST ] Cleaning up..."
    echo "[ TEST ] Test of $ARG complete!"
}

# Example usage:
check_languages "$1"

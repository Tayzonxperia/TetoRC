#/bin/bash

CFLAGS="-O2 -pipe -ffreestanding -s"
DEBUG_CFLAGS="-g -O0 -pipe -ffreestanding"
OPT_CFLAGS="-march=native -mtune=native -O3 -flto -pipe -fno-exceptions -fno-rtti -fdata-sections -ffunction-sections -ffreestanding -s"
SMALL_CFLAGS="-Os -flto -pipe -s"
TETORC="$(pwd)/../core/main.nim"

echo "[ INFO ] How would you like to build TetoRC?"
read -p "[ PROMPT ] Do you want to define anything? " DEFINE
if [ -z "$DEFINE" ]; then
	DEFINE="-d:null"
fi
echo "You have defined '$DEFINE'"
echo "Availible preset options for compile:"
echo "Default (1)"
echo "Debug (2)"
echo "Optimized (3)"
echo "Tiny (4)"
read -p "[ PROMPT ] Select from options above " ANS

case "$ANS" in
1)

	echo "[ INFO ] Building TetoRC with option $ANS"
	OUT="tetorc"
	time nim c -f -d:release "$DEFINE" -d:strip --threads:on --opt:speed --app:console --passC:"$CFLAGS" --passL:"$CFLAGS" -o:"$OUT" "$TETORC" && echo \
	"[ INFO ] TetoRC has been compiled!"
	;;

2)

	echo "[ INFO ] Building TetoRC with option $ANS"
	OUT="tetorc-debug"
	time nim c -f -d:debug "$DEFINE" --app:console --passC:"$DEBUG_CFLAGS" --passL:"$DEBUG_CFLAGS" -o:"$OUT" "$TETORC" && echo \
	"[ INFO ] TetoRC has been compiled!"
	;;

3)

	echo "[ INFO ] Building TetoRC with option $ANS"
	OUT="tetorc-optimized"
	time nim c -f -d:release "$DEFINE" -d:strip --threads:on --opt:speed --app:console --passC:"$OPT_CFLAGS" --passL:"$OPT_CFLAGS" -o:"$OUT" "$TETORC" && echo \
	"[ INFO ] TetoRC has been compiled!"
	;;

4)

	echo "[ INFO ] Building TetoRC with option $ANS"
	OUT="tetorc-tiny"
	time nim c -f -d:release "$DEFINE" -d:strip --threads:on --opt:size --app:console --passC:"$SMALL_CFLAGS" --passL:"$SMALL_CFLAGS" -o:"$OUT" "$TETORC" && echo \
	"[ INFO ] TetoRC has been compiled!"
	;;
	
*)

	echo "[ INFO ] Incorrect choice! Aborting..."
	exit 1
	;;
esac

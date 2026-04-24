#!/bin/bash

BIN_PATH=$PWD/bin/

mkdir -p "$BIN_PATH"

LOVE_APPIMAGE_FILE=love-11.5-x86_64.AppImage
APPIMAGE_TOOL_NAME=appimagetool-x86_64.AppImage

# Checking if the love AppImage doesn't exist. If now, installing it
if [ ! -f "$BIN_PATH/$LOVE_APPIMAGE_FILE" ]; then
	echo "Could not find love AppImage."
	echo "Downloading love-11.5 AppImage."
	# Downloading the love AppImage
	wget -O "$BIN_PATH/$LOVE_APPIMAGE_FILE" "https://github.com/love2d/love/releases/download/11.5/love-11.5-x86_64.AppImage"

	# Making it executable
	chmod +x $BIN_PATH/$LOVE_APPIMAGE_FILE
fi

# Checking if the AppImage tool doesn't exist. If now, installing it
if [ ! -f "$BIN_PATH/$APPIMAGE_TOOL_NAME" ]; then
	echo "Could not file the AppImage tool."
	echo "Downloading now."
	# Downloading the AppImage tool
	wget -O "$BIN_PATH/$APPIMAGE_TOOL_NAME" "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"

	# Making it executable
	chmod +x $BIN_PATH/$APPIMAGE_TOOL_NAME
fi

# Clean build directory if it exists
if [ -d "build" ]; then
	rm -rf build
fi

rm -f build/Zero_Percent_Juice.AppImage

rm -f Zero_Percent_Juice.love

mkdir build

# At this point if we have installed the tools we can begin to build the game AppImage

# Creating the .love file
zip -9 -r Zero_Percent_Juice.love .

$BIN_PATH/$LOVE_APPIMAGE_FILE --appimage-extract
mv $PWD/squashfs-root/ $PWD/build

cat $PWD/build/squashfs-root/bin/love $PWD/Zero_Percent_Juice.love >$PWD/build/squashfs-root/bin/Zero_Percent_Juice
chmod +x $PWD/build/squashfs-root/bin/Zero_Percent_Juice

rm $PWD/build/squashfs-root/bin/love

# Copy JSON.lua to location in LUA_PATH
cp $PWD/vendor/share/lua/5.1/JSON.lua $PWD/build/squashfs-root/share/lua/5.1/JSON.lua

# rm $PWD/build/squashfs-root/love.desktop $PWD/build/squashfs-root/love.svg $PWD/build/squashfs-root/AppRun
cp $PWD/linux_appimage_files/love.desktop $PWD/linux_appimage_files/love.svg $PWD/linux_appimage_files/AppRun $PWD/build/squashfs-root

# Final AppImage Build (hopefully)
$BIN_PATH/$APPIMAGE_TOOL_NAME $PWD/build/squashfs-root $PWD/build/Zero_Percent_Juice.AppImage

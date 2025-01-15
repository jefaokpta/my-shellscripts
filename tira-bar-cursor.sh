#!/bin/bash

# Get the appimagetool appimage from the releases page here: https://github.com/AppImage/appimagetool

# Step 1: Extract the AppImage
./Cursor.AppImage --appimage-extract

# Step 2: Define the path to the target file
TARGET_FILE="squashfs-root/resources/app/out/vs/code/electron-main/main.js"

# Step 3: Replace all occurrences of ",minHeight" with ",frame:false,minHeight"
sed -i 's/,minHeight/,frame:false,minHeight/g' "$TARGET_FILE"

# Step 4: Repackage the AppImage using appimagetool
./appimagetool-x86_64.AppImage squashfs-root/

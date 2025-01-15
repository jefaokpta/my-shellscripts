#!/bin/bash

# I was having the same issue with gnome on Fedora. Two title bars. Of course, the suggested solution for reverting to native title bar worked for me, 
# I kinda liked the custom titlebar from the vscodium that I am using on the side.

# Since I know that it’s electron app, there has to be just a single parameter change either in some JSON or JS file. 
# So I extracted the AppImage file.

# Get the appimagetool appimage from the releases page here: https://github.com/AppImage/appimagetool

# Step 1: Extract the AppImage
./Cursor.AppImage --appimage-extract

# Step 2: Define the path to the target file
TARGET_FILE="squashfs-root/resources/app/out/vs/code/electron-main/main.js"

# Step 3: Replace all occurrences of ",minHeight" with ",frame:false,minHeight"
sed -i 's/,minHeight/,frame:false,minHeight/g' "$TARGET_FILE"

# Step 4: Repackage the AppImage using appimagetool
./appimagetool-x86_64.AppImage squashfs-root/

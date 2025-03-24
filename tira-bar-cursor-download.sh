#!/bin/bash
set -ex

# Download Cursor IDE
wget https://downloads.cursor.com/production/b6fb41b5f36bda05cab7109606e7404a65d1ff32/linux/x64/Cursor-0.47.9-x86_64.AppImage -O ./Cursor_orig.AppImage
chmod +x ./Cursor_orig.AppImage

# Extract the AppImage
./Cursor_orig.AppImage --appimage-extract
rm ./Cursor_orig.AppImage

# Fix it by replacing all occurrences of ",minHeight" with ",frame:false,minHeight"
find squashfs-root/ -type f -name '*.js' \
  -exec grep -l ,minHeight {} \; \
  -exec sed -i 's/,minHeight/,frame:false,minHeight/g' {} \;

# Download appimagetool
wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage -O ./appimagetool-x86_64.AppImage
chmod +x ./appimagetool-x86_64.AppImage

# Repackage the AppImage using appimagetool
./appimagetool-x86_64.AppImage squashfs-root/

# Cleaning Up
rm ./appimagetool-x86_64.AppImage
rm -rf squashfs-root/
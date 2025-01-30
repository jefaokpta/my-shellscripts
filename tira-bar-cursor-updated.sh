#!/bin/bash
set -ex


# Extract the AppImage
./cursor.appimage --appimage-extract

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
#!/bin/bash
gameName="rotmg"
gameVersion=0.0.3

mkdir ./bin/v$gameVersion

if [ -f "./bin/v$gameVersion/$gameName-$gameVersion.love" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion.love ./bin/v$gameVersion/$gameName-$gameVersion.AppImage
fi

zip -9 -r ./bin/v$gameVersion/$gameName-$gameVersion.love ./src ./main.lua ./lib
cat /usr/bin/love ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion.AppImage
chmod a+x ./bin/v$gameVersion/$gameName-$gameVersion.AppImage

if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win32.exe" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe
fi

cat ../../../Téléchargements/love-11.3-win32/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe


if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win64.exe" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
fi

cat ../../../Téléchargements/love-11.3-win64/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
#!/bin/bash
love2dPath = ../../../Téléchargements/love-11.3
gameName="rotmg"
gameVersion=0.0.4

if [ $1 != "" ]; then
    gameVersion=$1
fi

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

cat $love2dPath-win32/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe


if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win64.exe" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
fi

cat $love2dPath-win64/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
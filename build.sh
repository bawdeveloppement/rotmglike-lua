#!/bin/bash
love2dPath="./debug/love"
gameName="rotmg"
gameVersion=0.0.4
shouldOverwrite=false

if [ $1 != "" ]; then
    gameVersion=$1
fi

mkdir ./bin
mkdir ./bin/v$gameVersion

if [ -d "./bin" ]; then
    echo "yeah"
fi

if [ $shouldOverwrite == true ]; then
    echo "dazdazd"
fi

if [ -f "./bin/v$gameVersion/$gameName-$gameVersion.love" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion.love ./bin/v$gameVersion/$gameName-$gameVersion.AppImage
fi

if [ -f "./v$gameVersion.lua" ]; then
    mv main.lua old.lua
    mv v$gameVersion.lua main.lua  
fi

zip -9 -r ./bin/v$gameVersion/$gameName-$gameVersion.love ./src ./main.lua ./lib

if [ -f "./old.lua" ]; then
    mv main.lua v$gameVersion.lua  
    mv old.lua main.lua
fi

# LINUX
cat /usr/bin/love ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion.AppImage
chmod a+x ./bin/v$gameVersion/$gameName-$gameVersion.AppImage

# WIN 32
if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win32.exe" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe
fi

if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win32.zip" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion-win32.zip
fi
    

cat $love2dPath-win32/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe
zip -9 -jr ./bin/v$gameVersion/$gameName-$gameVersion-win32.zip ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe $love2dPath-win32/
rm ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe

if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win64.exe" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
fi
if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win64.zip" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion-win64.zip
fi

cat $love2dPath-win64/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
zip -9 -jr ./bin/v$gameVersion/$gameName-$gameVersion-win64.zip ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe $love2dPath-win64/
rm ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
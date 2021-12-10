#!/bin/bash
gameName="rotmg"
gameVersion=0.0.3

mkdir ./bin/v$gameVersion

if [ -f "./bin/v$gameVersion/$gameName-$gameVersion.love" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion.love
    zip -9 -r ./bin/v$gameVersion/$gameName-$gameVersion.love ./src ./main.lua ./lib
else
    zip -9 -r ./bin/v$gameVersion/$gameName-$gameVersion.love ./src ./main.lua ./lib
fi

if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win32.exe" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe
    cat ../../../Téléchargements/love-11.3-win32/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe
else
    cat ../../../Téléchargements/love-11.3-win32/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe
fi


if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win64.exe" ]; then
    rm ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
    cat ../../../Téléchargements/love-11.3-win64/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
else
    cat ../../../Téléchargements/love-11.3-win64/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
fi
#!/bin/bash
love2dPath="./debug/love"
gameName="rotmg"
gameVersion=0.0.4
shouldOverwrite=0

if [ $1 != "" ]; then
    gameVersion=$1
fi

if [ $2 != "" ]; then
    shouldOverwrite=$2
fi

if ! [ -d "./bin" ]; then
    mkdir ./bin
fi



function build {
    mkdir ./bin/v$gameVersion

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
    cat $love2dPath-win32/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe
    zip -9 -jr ./bin/v$gameVersion/$gameName-$gameVersion-win32.zip ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe $love2dPath-win32/
    rm ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe

    cat $love2dPath-win64/love.exe ./bin/v$gameVersion/$gameName-$gameVersion.love > ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
    zip -9 -jr ./bin/v$gameVersion/$gameName-$gameVersion-win64.zip ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe $love2dPath-win64/
    rm ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
}

function clean_build {
    if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win32.exe" ]; then
        rm ./bin/v$gameVersion/$gameName-$gameVersion-win32.exe
    fi

    if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win32.zip" ]; then
        rm ./bin/v$gameVersion/$gameName-$gameVersion-win32.zip
    fi

    if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win64.exe" ]; then
        rm ./bin/v$gameVersion/$gameName-$gameVersion-win64.exe
    fi

    if [ -f "./bin/v$gameVersion/$gameName-$gameVersion-win64.zip" ]; then
        rm ./bin/v$gameVersion/$gameName-$gameVersion-win64.zip
    fi
}

if [ -d "./bin/v$gameVersion" ]; then
    if [ $shouldOverwrite == 1 ]; then
        clean_build
        build
    else
        echo "The build $gameVersion already exist."
        echo "Pass in command line : ./build.sh v$gameVersion 1 to overwrite"
    fi
else
    build
fi
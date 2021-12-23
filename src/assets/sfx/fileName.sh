#!/bin/bash


touch sounds.lua

printf %"s\n" "return {" > sounds.lua
for dir in */*.mp3; do
  printf %"s\n" "\"$dir\"," >> sounds.lua
done
for dir in *.mp3; do
  printf %"s\n" "\"$dir\"," >> sounds.lua
done
printf %"s\n" "}" >> sounds.lua

# The script could be better but i suck ...

# Rename EmbeddedAssets_fileNameEmbed_.png
# To fileName.png

for file in $assetDir/*.png; do mv "$file" "${file/Embed_/.png}"; done
for file in $assetDir/*.png; do mv "$file" "${file/_/.png}"; done
for file in $assetDir/*.png; do mv "$file" "${file/EmbeddedAssets_/}"; done

# And list
#!/bin/bash

touch textures.lua

printf %"s\n" "return {" > textures.lua
for dir in */*; do
  printf %"s\n" "\"$dir\"," >> textures.lua
done
for dir in *.mp3; do
  printf %"s\n" "\"$dir\"," >> textures.lua
done
printf %"s\n" "}" >> textures.lua

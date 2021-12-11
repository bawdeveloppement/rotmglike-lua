local Map = require(_G.libDir .. "middleclass")("Map")

function Map:initialize( mapname, scale )
    print(_G.baseDir .."src.assets.worlds.".. mapname .. "." .. mapname)
    self.mapData = require(_G.baseDir .."src.assets.worlds.".. mapname .. "." .. mapname)
    self.scale = scale or 4
    
    for i, v in pairs(self.mapData.tilesets) do
        self.mapData.tilesets[i].image = love.graphics.newImage("src/assets/textures/rotmg/EmbeddedAssets_"..v.name.."Embed_.png")
    end

    self.quads = {}

    for i, v in ipairs(self.mapData.tilesets) do
        local w, h = self.mapData.tilesets[i].image:getDimensions()
        for y = 0, (h / self.mapData.tileheight) - 1 do
            for x = 0, (w / self.mapData.tilewidth) - 1 do
                local quad = love.graphics.newQuad(
                    x * self.mapData.tilewidth,
                    y * self.mapData.tileheight,
                    self.mapData.tilewidth,
                    self.mapData.tileheight,
                    w, h
                )
                table.insert(self.quads, quad)
            end
        end
    end
end

function Map:update()
end

function Map:draw()
    for i, layer in ipairs(self.mapData.layers) do
        if layer.type == "tilelayer" then
            for y = 0, layer.height - 1 do
                for x = 0, layer.width - 1 do
                    local index = (x + y * layer.width) + 1
                    local tid = layer.data[index]
    
                    local targetTileset = 0
                    for i, v in ipairs(self.mapData.tilesets) do
                        if tid > v.firstgid then
                            targetTileset = i
                        end
                    end
    
                    if tid ~= 0 then
                        local quad = self.quads[tid]
                        local xx =  x * (self.mapData.tilewidth * self.scale)
                        local yy =  y * (self.mapData.tileheight * self.scale)
                        
                        love.graphics.draw(
                            self.mapData.tilesets[targetTileset].image,
                            quad,
                            xx,
                            yy,
                            0,
                            self.scale,self.scale
                        )
                    end
                end
            end
        end
        if layer.type == "objectgroup" then
            for ii, obj in ipairs(layer.objects) do
                local targetTileset = 0
                for i, tileset in ipairs(self.mapData.tilesets) do
                    if obj.gid > tileset.firstgid then
                        targetTileset = i
                    end
                end
                local quad = self.quads[obj.gid]
                love.graphics.draw(
                    self.mapData.tilesets[targetTileset].image,
                    quad,
                    obj.x * self.scale,
                    obj.y * self.scale,
                    0,
                    self.scale,self.scale
                )
            end
        end
    end
end

return Map
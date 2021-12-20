local World = require(_G.libDir .. "middleclass")("World");

function World:initialize( world_name, world_data, world_worldScale )
    self.worldName = world_name
    self.worldData = world_data
    self.worldScale = world_worldScale or 4

    for i, v in pairs(self.worldData.tilesets) do
        self.worldData.tilesets[i].image = love.graphics.newImage("src/assets/textures/rotmg/EmbeddedAssets_"..v.name.."Embed_.png")
    end

    self.quads = {}

    for i, v in ipairs(self.worldData.tilesets) do
        local w, h = self.worldData.tilesets[i].image:getDimensions()
        for y = 0, (h / self.worldData.tileheight) - 1 do
            for x = 0, (w / self.worldData.tilewidth) - 1 do
                local quad = love.graphics.newQuad(
                    x * self.worldData.tilewidth,
                    y * self.worldData.tileheight,
                    self.worldData.tilewidth,
                    self.worldData.tileheight,
                    w, h
                )
                table.insert(self.quads, quad)
            end
        end
    end

    self.entities = {}

    for li, layer in ipairs(self.worldData.layers) do
        if layer.type == "objectgroup" then
            for oi, obj in ipairs(layer.objects) do
                for i, k in pairs(require(_G.srcDir .. "entities.entities")) do

                    if obj.name == k then
                        if obj.name == "monster_spawner" then
                            local ent = require(_G.srcDir .. "entities.".. k):new(
                                self,
                                {
                                    name = obj.properties["entityId"],
                                    position = { x = obj.x * self.worldScale, y = obj.y * self.worldScale}
                                }
                            );
                            table.insert(self.entities, ent)
                        else
                            local ent = require(_G.srcDir .. "entities.".. k):new(
                                self,
                                {
                                    position = { x = obj.x * self.worldScale, y = obj.y * self.worldScale}
                                }
                            );
                            table.insert(self.entities, ent)
                        end

                    end
                end
            end
        end
    end
end


--#region Callbacks
function World:update()
    for i, entity in ipairs(self.entities) do
        if entity.markDestroy ~= true then
            entity:update()
        else
            table.remove(self.entities, i);
        end
    end
end

function World:draw()
    for i, layer in ipairs(self.worldData.layers) do
        if layer.type == "tilelayer" then
            for y = 0, layer.height - 1 do
                for x = 0, layer.width - 1 do
                    local index = (x + y * layer.width) + 1
                    local tid = layer.data[index]
    
                    local targetTileset = 0
                    for i, v in ipairs(self.worldData.tilesets) do
                        if tid > v.firstgid then
                            targetTileset = i
                        end
                    end
    
                    if tid ~= 0 then
                        local quad = self.quads[tid]
                        local xx =  x * (self.worldData.tilewidth * self.worldScale)
                        local yy =  y * (self.worldData.tileheight * self.worldScale)
                        
                        love.graphics.draw(
                            self.worldData.tilesets[targetTileset].image,
                            quad,
                            xx,
                            yy,
                            0,
                            self.worldScale,self.worldScale
                        )
                    end
                end
            end
        end
        if layer.type == "objectgroup" then
            for ii, obj in ipairs(layer.objects) do
                local targetTileset = 0
                for i, tileset in ipairs(self.worldData.tilesets) do
                    if obj.gid ~= nil then
                        if obj.gid > tileset.firstgid then
                            targetTileset = i
                        end
                    end
                end
                if targetTileset ~= 0 then
                    local quad = self.quads[obj.gid]
                    love.graphics.draw(
                        self.worldData.tilesets[targetTileset].image,
                        quad,
                        obj.x * self.worldScale,
                        obj.y * self.worldScale,
                        0,
                        self.worldScale,self.worldScale
                    )
                end
            end
        end
    end

    for i, entity in ipairs(self.entities) do
        entity:draw()
    end
end

function World:keyreleased(...)
    for i, v in ipairs(self.entities) do
        if v.keyreleased ~= nil then
            v:keyreleased(...)
        end
    end
end

function World:keypressed(...)
    for i, v in ipairs(self.entities) do
        if v.keypressed ~= nil then
            v:keypressed(...)
        end
    end
end

function World:mousereleased(...)
    for i, v in ipairs(self.entities) do
        if v.mousereleased ~= nil then
            v:mousereleased(...)
        end
    end
end

function World:mousepressed(...)
    for i, v in ipairs(self.entities) do
        if v.mousepressed ~= nil then
            v:mousepressed(...)
        end
    end
end
--#endregion

function World:addEntity( entity )
    if entity ~= nil then
        table.insert(self.entities, #self.entities + 1, entity);
    end
end

function World:removeTile( layerId, dataId )
    if self.worldData.layers[layerId] ~= nil then
        -- local dataId = 0
        -- for i, v in ipairs (self.worldData.layers[layerId].data) do
        --     if i == 
        -- end
        table.remove(self.worldData.layers[layerId].data, dataId)
    end
end

function World:getEntityByName ()
    
end

-- Return the entity by id or nil
function World:getEntityById( entityId )
    for i, v in ipairs(self.entities) do
        if (v.id == entityId) then return self.entities[i]; end
    end
    return nil
end

function World:getEntitiesByClassName ( className )
    local foundEntities = {}
    for i, v in ipairs(self.entities) do
        print(v.name)
    end
    return foundEntities
end

function World:getEntitiesByComponentName ( componentName )
    local foundEntities = {}
    for i, v in ipairs(self.entities) do
        if v:getComponent(componentName) ~= nil then
            table.insert(foundEntities, #foundEntities + 1, self.entities[i]);
        end
    end
    return foundEntities
end

-- Get entities when one of them have one the componentList in fn.arg
function World:getEntitiesWithOneOf ( componentList )
    local foundEntities = {}
    for ei, entity in ipairs(self.entities) do
        for ci, component in ipairs( componentList ) do
            if entity:getComponent( component.name ) ~= nil and foundEntities[entity] == nil then
                table.insert(foundEntities, #foundEntities + 1, entity);
            end
        end
    end
    return foundEntities
end

-- Return a table with entities which have a strict list of components equals to fn arg
function World:getEntitiesWithAtLeast ( componentList )
    local foundEntities = {}
    for ei, entity in ipairs(self.entities) do
        local componentMatchedCount = 0
        for ci, componentName in ipairs( componentList ) do
            if entity:getComponent( componentName ) ~= nil and foundEntities[entity] == nil then
                componentMatchedCount = componentMatchedCount + 1
            end
        end
        if componentMatchedCount == #componentList then
            table.insert(foundEntities, #foundEntities + 1, entity);
        end
    end
    return foundEntities
end
function World:getEntitiesCount()
    return #self.entities
end
return World
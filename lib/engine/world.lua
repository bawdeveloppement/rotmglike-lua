local World = require(_G.libDir .. "middleclass")("World");

World.static.worlds = {}

function World:initialize( screen, active,  world_name, world_data, world_worldScale )
    self.screen = screen
    
    self.world_name = world_name
    self.world_data = world_data
    self.world_scale = world_worldScale or 4
    self.world_pos = { x = 0, y = 0 }

    self.isActive = active
    self.quads = {}
    self.entities = {}

    self:load()
end

function World:load()
    for i, v in pairs(self.world_data.tilesets) do
        self.world_data.tilesets[i].image = _G.xle.ResourcesManager:getTexture(v.name)
        local w, h = self.world_data.tilesets[i].image:getDimensions()
        for y = 0, (h / self.world_data.tileheight) - 1 do
            for x = 0, (w / self.world_data.tilewidth) - 1 do
                local quad = love.graphics.newQuad(
                    x * self.world_data.tilewidth,
                    y * self.world_data.tileheight,
                    self.world_data.tilewidth,
                    self.world_data.tileheight,
                    w, h
                )
                table.insert(self.quads, quad)
            end
        end
    end

    for li, layer in ipairs(self.world_data.layers) do
        if layer.type == "objectgroup" then
            for oi, obj in ipairs(layer.objects) do
                for i, k in pairs(require(_G.srcDir .. "entities.entities")) do
                    if obj.name == k then
                        if obj.name == "monster_spawner" then
                            local ent = require(_G.srcDir .. "entities.".. k):new(
                                self,
                                {
                                    name = obj.properties["entityId"],
                                    scale = self.world_scale,
                                    position = { x = obj.x * self.world_scale, y = obj.y * self.world_scale}
                                }
                            );
                            table.insert(self.entities, ent)
                        else
                            local ent = require(_G.srcDir .. "entities.".. k):new(
                                self,
                                {
                                    name = obj.name,
                                    scale = self.world_scale,
                                    position = { x = obj.x * self.world_scale, y = obj.y * self.world_scale},
                                    properties = obj.properties
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
function World:update(...)
    for i, entity in ipairs(self.entities) do
        if entity.markDestroy ~= true then
            entity:update(...)
        else
            table.remove(self.entities, i);
        end
    end
end


function World:draw()
    for i, layer in ipairs(self.world_data.layers) do
        if layer.type == "tilelayer" then
            for y = 0, layer.height - 1 do
                for x = 0, layer.width - 1 do
                    local index = (x + y * layer.width) + 1
                    local tid = layer.data[index]
    
                    local targetTileset = 0
                    for i, v in ipairs(self.world_data.tilesets) do
                        if tid > v.firstgid then
                            targetTileset = i
                        end
                    end
    
                    if tid ~= 0 then
                        local quad = self.quads[tid]
                        local xx =  x * (self.world_data.tilewidth * self.world_scale)
                        local yy =  y * (self.world_data.tileheight * self.world_scale)
                        
                        love.graphics.draw(
                            self.world_data.tilesets[targetTileset].image,
                            quad,
                            xx,
                            yy,
                            0,
                            self.world_scale,self.world_scale
                        )
                    end
                end
            end
        end
        if layer.type == "objectgroup" then
            for ii, obj in ipairs(layer.objects) do
                local targetTileset = 0
                for i, tileset in ipairs(self.world_data.tilesets) do
                    if obj.gid ~= nil then
                        if obj.gid > tileset.firstgid then
                            targetTileset = i
                        end
                    end
                end
                if targetTileset ~= 0 then
                    local quad = self.quads[obj.gid]
                    love.graphics.draw(
                        self.world_data.tilesets[targetTileset].image,
                        quad,
                        self.world_pos.x + obj.x * self.world_scale,
                        self.world_pos.y + obj.y * self.world_scale,
                        0,
                        self.world_scale,self.world_scale
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
    if self.world_data.layers[layerId] ~= nil then
        -- local dataId = 0
        -- for i, v in ipairs (self.world_data.layers[layerId].data) do
        --     if i == 
        -- end
        table.remove(self.world_data.layers[layerId].data, dataId)
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
            if entity:getComponent( componentName ) ~= nil then
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
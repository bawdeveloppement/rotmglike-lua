local Entity = require(_G.libDir .. "middleclass")("Entity")

Entity.static.entities = {}

function Entity:initialize( world, id, name, cmpts, children )
    self.world = world
    self.id = id
    self.name = name
    self.components = {}
    self.children = {}
    self.markDestroy = false

    if type(cmpts) == "table" then
        for component in ipairs(cmpts) do
            self:addComponent(cmpts[component])
        end
    end
end

function Entity:getName ()
    return self.name
end

function Entity:addChild ()
end

function Entity:getComponent ( name )
    if self.components[name] ~= nil then
        return self.components[name]
    else
        return nil
    end
end

function Entity:addComponent ( component )
    if self:getComponent( component.class.name ) == nil then
        self.components[component.class.name] = component.class:new(self, component.data or {})
    else
        print(component.class.name .. " is already used.")
    end
end

function Entity:removeComponent ( name )
    for i in ipairs( self.components ) do
        if self.components[i].name == name then
            table.remove(self.components, i);
        end
    end
end

function Entity:update (...)
    if self.components ~= nil then
        
        for k, v in pairs (self.components) do
            if v.update ~= nil then
                v:update(...)
            end
        end
    end
end

function Entity:draw (...)
    if self.components ~= nil then
        for k, v in pairs (self.components) do
            if v.draw ~= nil then
                v:draw(...)
            end
        end
    end
end

function Entity:mousereleased (...)
    if self.components ~= nil then
        for k, v in pairs (self.components) do
            if v.mousereleased ~= nil then
                v:mousereleased(...)
            end
        end
    end
end

function Entity:mousepressed (...)
    if self.components ~= nil then
        for k, v in pairs (self.components) do
            if v.mousepressed ~= nil then
                v:mousepressed(...)
            end
        end
    end
end

function Entity:keypressed (...)
    if self.components ~= nil then
        for k, v in pairs (self.components) do
            if v.keypressed ~= nil then
                v:keypressed(...)
            end
        end
    end
end

function Entity:keyreleased (...)
    if self.components ~= nil then
        for k, v in pairs (self.components) do
            if v.keyreleased ~= nil then
                v:keyreleased(...)
            end
        end
    end
end

return Entity
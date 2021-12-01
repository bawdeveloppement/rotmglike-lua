local Entity = require("engine.middleclass")("Entity")

Entity.static.entities = {}

function Entity:initialize( name, cmpts )
    self.name = name
    self.components = {}
    
    for component in ipairs(cmpts) do
        self:addComponent(cmpts[component])
    end
end

function Entity:getName()
    return self.name
end

function Entity:getComponent ( name )
    return self.components[name] or nil
end

function Entity:addComponent ( component )
    if self:getComponent( component.name ) == nil then
        local instancied = component:new(self)
        self.components[component.name] = instancied
    else 
        print(component.name .. " is already used.")
    end
end

function Entity:removeComponent ( name )
    for i in ipairs( self.components ) do
        if self.components[i].name == name then
            table.remove(self.components, i);
        end
    end
end

function Entity:update ()
    if self.components ~= nil or #self.components > 0 then
        for k, v in pairs (self.components) do
            if v.update ~= nil then
                v:update()
            end
        end
    end
end

function Entity:draw ()
    for k, v in pairs (self.components) do
        if v.draw ~= nil then
            v:draw()
        end
    end
end

return Entity
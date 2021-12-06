local Entity = require(_G.libDir .. "middleclass")("Entity")

Entity.static.entities = {}

function Entity:initialize( name, cmpts )
    self.name = name
    self.components = {}
    
    if type(cmpts) == "table"  then
        for component in ipairs(cmpts) do
            self:addComponent(cmpts[component])
        end
    end
end

function Entity:getName()
    return self.name
end

function Entity:getComponent ( name )
    return self.components[name] or nil
end

function Entity:addComponent ( component )
    if self:getComponent( component.class.name ) == nil then
        self.components[component.class.name] = component.class:new(self, component.data or {})
    else
        print(component.class.name .. " is already used.")
    end
    print(self.components)
end

function Entity:removeComponent ( name )
    for i in ipairs( self.components ) do
        if self.components[i].name == name then
            table.remove(self.components, i);
        end
    end
end

function Entity:update ()
    if self.components ~= nil then
        for k, v in pairs (self.components) do
            if v.update ~= nil then
                v:update()
            end
        end
    end
end

function Entity:draw ()
    if self.components ~= nil then
        for k, v in pairs (self.components) do
            if v.draw ~= nil then
                v:draw()
            end
        end
    end
end

return Entity
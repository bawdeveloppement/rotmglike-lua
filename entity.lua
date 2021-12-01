local Entity = require("engine.middleclass")("Entity")

Entity.static.entities = {}

function Entity:initialize( name )
    self.name = name
end

function Entity:update ()
    for k, v in pairs (self.components) do
       v:update() 
    end
end

function Entity:draw ()
    for k, v in pairs (self.components) do
       v:draw() 
    end
end

return Entity
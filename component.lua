local Component = require("engine.middleclass")("Component")

Component.static.entities = {}

function Component:initialize( name, data )
    self.name = name
end

function Component:update ()
    for k, v in pairs (self.components) do
       v:update() 
    end
end

function Component:draw ()
    for k, v in pairs (self.components) do
       v:draw() 
    end
end

return Component
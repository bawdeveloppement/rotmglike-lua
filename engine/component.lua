local Component = require("engine.middleclass")("Component")

Component.static.entities = {}

function Component:initialize( name, data )
    self.name = name
end

function Component:update ()
end

function Component:draw ()
end

return Component
local Component = require(_G.engineDir .. "middleclass")("Component")

function Component:initialize( entity )
    self.entity = entity
    self.active = true
end

function Component:setActive ( active )
    self.active = active
end

return Component
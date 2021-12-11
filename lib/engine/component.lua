local Component = require(_G.libDir .. "middleclass")("Component")

function Component:initialize( entity )
    self.entity = entity
    self.active = true
end

function Component:setActive ( active )
    self.active = active
end

function Component:getComponent ( comptName )
    return self.entity:getComponent( comptName )
end

return Component
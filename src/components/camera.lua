local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CameraComponent = Class("CameraComponent", Component);


function CameraComponent:initialize( entity, data )
    Component.initialize(self, entity)

    local transform = self.entity:getComponent("TransformComponent");
    self.position = {
        x = transform.position.x + (data.x or 0),
        y = transform.position.y + (data.y or 0)
    }
end


return CameraComponent
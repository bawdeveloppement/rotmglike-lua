local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CameraComponent = Class("CameraComponent", Component);


function CameraComponent:initialize( entity, data )
    Component.initialize(self, entity)
end


return CameraComponent
local Component = require(_G.engineDir .. "component")
local Class = require(_G.engineDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CollisionComponent = Class("Collision", Component);

CollisionComponent.static.name = "Collision"

function CollisionComponent:initialize( parent )
    Component.initialize(self, parent)
    self.name = "Collision"
    self.isInCollision = false
end

return CollisionComponent
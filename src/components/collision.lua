local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CollisionComponent = Class("CollisionComponent", Component);

CollisionComponent.static.name = "CollisionComponent"

function CollisionComponent:initialize( parent )
    Component.initialize(self, parent)
    self.name = "CollisionComponent"
    self.isInCollision = false
end

return CollisionComponent
local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CollisionComponent = Class("CollisionComponent", Component);


function CollisionComponent:initialize( parent )
    Component.initialize(self, parent)
    self.isInCollision = false
end

return CollisionComponent
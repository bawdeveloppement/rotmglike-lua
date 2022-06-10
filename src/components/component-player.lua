local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "Move" and inherit of Component
local PlayerComponent = Class("PlayerComponent", Component);

PlayerComponent.static.name = "PlayerComponent"

function PlayerComponent:initialize( parent )
    Component.initialize(self, parent)
end

return PlayerComponent
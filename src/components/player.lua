local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "Player" and inherit of Component
local PlayerComponent = Class("PlayerComponent", Component);

function PlayerComponent:initialize( parent )
    Component.initialize(self, parent)
end

return PlayerComponent
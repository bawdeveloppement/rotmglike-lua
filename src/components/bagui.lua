local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local BagUIComponent = Class("BagUI", Component);

BagUIComponent.static.name = "BagUI"

function BagUIComponent:initialize( parent )
    Component.initialize(self, parent)
    self.name = "BagUI"
end

function BagUIComponent:update()
end

return BagUIComponent
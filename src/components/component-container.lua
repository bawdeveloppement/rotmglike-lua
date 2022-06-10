local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "Move" and inherit of Component
local ContainerComponent = Class("ContainerComponent", Component);

ContainerComponent.static.name = "ContainerComponent"

function ContainerComponent:initialize( parent, data )
    Component.initialize(self, parent)
    self.items = data.items
end



return ContainerComponent
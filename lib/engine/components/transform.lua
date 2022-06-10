local Component = require(_G.engineDir .. "component")
local Vector2 = require(_G.engineDir .. "utils.Vector2")
local Class = require(_G.libDir .. "middleclass")

local TransformComponent = Class("TransformComponent", Component)


function TransformComponent:initialize( parent, data)
    Component.initialize(self, parent );

    local position = data.position or {}
    local scale = data.scale or {}
    local rotation = data.rotation or {}

    self.position = Vector2:new(position.x or 0, position.y or 0);
    self.scale = Vector2:new(scale.x or 0, scale.y or 0);
    self.rotation = Vector2:new(rotation.x or 0, rotation.y or 0)
end

function TransformComponent:translate( v2 )
    self.position = v2
end

return TransformComponent
local Component = require(_G.engineDir .. "component")
local Class = require(_G.engineDir .. "middleclass")
local TransformComponent = Class("Transform", Component)
local Vector2 = require(_G.engineDir .. "utils.Vector2")

TransformComponent.static.name = "Transform"

function TransformComponent:initialize( parent )
    Component.initialize(self, parent );
    self.name = "Transform";
    self.position = Vector2:new(0, 0);
    self.scale = Vector2:new(0, 0);
    self.rotation = Vector2:new(0, 0)
end

function TransformComponent:translate( v2 )
    self.position = v2
end

function TransformComponent:update ()
end

function TransformComponent:draw ()
    
end

return TransformComponent
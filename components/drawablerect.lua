local Component = require(_G.engineDir .. "component")
local Class = require(_G.engineDir .. "middleclass")

-- Create a class called "Move" and inherit of Component
local DrawableRectComponent = Class("DrawableRect", Component);

DrawableRectComponent.static.name = "DrawableRect"

function DrawableRectComponent:initialize( parent, data )
    Component.initialize(self, parent)
    self.name = "Move";
    self.size = data.size or { width = 32, height = 32 }
    self.color = data.color or { 0.5, 0.7, 0.2, 255}
    self.center = data.center or false
end

function DrawableRectComponent:draw()
    local transform = self.entity:getComponent("Transform")
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", transform.position.x, transform.position.y, self.size.width, self.size.height)
    love.graphics.setColor(255,255,255,255)
end

return DrawableRectComponent
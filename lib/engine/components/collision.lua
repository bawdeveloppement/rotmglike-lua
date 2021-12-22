local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CollisionComponent = Class("CollisionComponent", Component);


function CollisionComponent:initialize( entity, data )
    Component.initialize(self, entity)

    local position = self.entity:getComponent("TransformComponent").position;
    local rect = self.entity:getComponent("SpriteComponent").rect;
    local scale = self.entity:getComponent("SpriteComponent").scale;

    position = {
        x = position.x + (data.x or 0) - 4,
        y = position.y + (data.y or 0) - 2
    }

    self.rect = rect

    self.isInCollision = {
        with = nil
    }
end

function CollisionComponent:draw()
    local transform = self.entity:getComponent("TransformComponent");
    love.graphics.setColor(0,1,0,1)
    love.graphics.rectangle("line", transform.position.x, transform.position.y, self.rect.width, self.rect.height)
    love.graphics.setColor(1,1,1,1)
end

return CollisionComponent
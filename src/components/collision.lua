local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CollisionComponent = Class("CollisionComponent", Component);


function CollisionComponent:initialize( entity, data )
    Component.initialize(self, entity)

    local transform = self.entity:getComponent("TransformComponent");
    self.position = {
        x = transform.position.x + (data.x or 0) - 4,
        y = transform.position.y + (data.y or 0) - 2
    }

    self.size = {
        width = data.width or 36,
        height = data.height or 36
    }

    self.isInCollision = {
        with = nil
    }
end

function CollisionComponent:update()
    local transform = self.entity:getComponent("TransformComponent");
    self.position.x = transform.position.x - 2;
    self.position.y = transform.position.y - 2;
end

function CollisionComponent:draw()
    love.graphics.setColor(0,1,0,1)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.width, self.size.height)
    love.graphics.setColor(1,1,1,1)
end

return CollisionComponent
local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

local CollisionComponent = Class("CollisionComponent", Component);


function CollisionComponent:initialize( entity, data )
    Component.initialize(self, entity)

    local position = self.entity:getComponent("TransformComponent").position;

    self.rect = data.rect;
    self.scale = data.scale or 1;

    position = {
        x = position.x + (data.x or 0) - 4,
        y = position.y + (data.y or 0) - 2
    }

    self.isInCollision = {
        with = nil
    }
end

function CollisionComponent:getRect()
    return {
        width = self.rect.width * self.scale,
        height = self.rect.height * self.scale
    }
end

function CollisionComponent:draw()
    if _G.isDebug then
        local transform = self.entity:getComponent("TransformComponent");
        love.graphics.setColor(0,1,0,1)
        love.graphics.rectangle("line", transform.position.x, transform.position.y, self.rect.width * self.scale, self.rect.height * self.scale)
        love.graphics.setColor(1,1,1,1)
    end
end

return CollisionComponent
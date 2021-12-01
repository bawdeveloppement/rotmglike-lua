local Component = require(_G.engineDir .. "component")
local Class = require(_G.engineDir .. "middleclass")

-- Create a class called "Move" and inherit of Component
local MoveComponent = Class("Move", Component);

MoveComponent.static.name = "Move"

function MoveComponent:initialize( parent )
    Component.initialize(self, parent)
    self.name = "Move";
end


function MoveComponent:update()
    local z = love.keyboard.isDown("z");
    local q = love.keyboard.isDown("q");
    local d = love.keyboard.isDown("d");
    local s = love.keyboard.isDown("s");

    local transform = self.entity:getComponent("Transform")
    local character = self.entity:getComponent("Character")
    if z then
        transform.position.y = transform.position.y - (5 + character.stats.speed * 0.1)
    end

    if q then
        transform.position.x = transform.position.x - (5 + character.stats.speed * 0.1)
    end

    if d then
        transform.position.x = transform.position.x + (5 + character.stats.speed * 0.1)
    end

    if s then
        transform.position.y = transform.position.y + (5 + character.stats.speed * 0.1)
    end
end

function MoveComponent:draw()
    local transform = self.entity:getComponent("Transform")

    love.graphics.rectangle("fill", transform.position.x, transform.position.y, 32, 32)
end

return MoveComponent
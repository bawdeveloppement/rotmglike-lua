local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "Move" and inherit of Component
local MoveComponent = Class("MoveComponent", Component);

MoveComponent.static.name = "MoveComponent"

function MoveComponent:initialize( parent )
    Component.initialize(self, parent)
    self.name = "MoveComponent";
end


function MoveComponent:update()
    local z = love.keyboard.isDown("z");
    local q = love.keyboard.isDown("q");
    local d = love.keyboard.isDown("d");
    local s = love.keyboard.isDown("s");

    local transform = self.entity:getComponent("TransformComponent")
    local character = self.entity:getComponent("CharacterComponent")
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

return MoveComponent
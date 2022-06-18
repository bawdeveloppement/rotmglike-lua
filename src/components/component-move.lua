local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "Move" and inherit of Component
local MoveComponent = Class("MoveComponent", Component);

function MoveComponent:initialize( parent )
    Component.initialize(self, parent)
end


function MoveComponent:update(...)
    local transform = self.entity:getComponent("TransformComponent")
    local character = self.entity:getComponent("CharacterComponent")

    local z = love.keyboard.isDown("z");
    local w = love.keyboard.isDown("w");
    local q = love.keyboard.isDown("q");
    local a = love.keyboard.isDown("a");
    local d = love.keyboard.isDown("d");
    local s = love.keyboard.isDown("s");

    if z or w then
        transform.position.y = transform.position.y - (5 + (character.stats.speed.base + character.stats.speed.equipment) * 0.1)
    end

    if q or a then
        transform.position.x = transform.position.x - (5 + (character.stats.speed.base + character.stats.speed.equipment) * 0.1)
    end

    if d then
        transform.position.x = transform.position.x + (5 + (character.stats.speed.base + character.stats.speed.equipment) * 0.1)
    end

    if s then
        transform.position.y = transform.position.y + (5 + (character.stats.speed.base + character.stats.speed.equipment) * 0.1)
    end

    _G.camera:lookAt(transform.position.x, transform.position.y)
end

return MoveComponent
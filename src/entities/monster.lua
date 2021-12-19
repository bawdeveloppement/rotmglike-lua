-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local Entity = require(_G.engineDir.."entity")

local MonsterAIComponent = require(_G.srcDir .. "components.monster_ai")
local CollisionComponent = require(_G.srcDir .. "components.collision")
local CharacterComponent = require(_G.srcDir .. "components.character")

local Monster = require(_G.libDir .. "middleclass")("Monster", Entity)

function Monster:initialize ( world, data)
    Entity.initialize(self, world, "Monster#"..world:getEntitiesCount(), data.name, {
        { class = Transform, data = data },
        { class = Sprite, data = { rect = { width = 32, height = 32 }, center = true }},
        { class = CharacterComponent },
        { class = CollisionComponent },
        { class = MonsterAIComponent }
    });

end

function Monster:draw()
    Entity.draw(self)
    local position = self:getComponent("TransformComponent").position
    local character = self:getComponent("CharacterComponent")

    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle("fill", position.x, position.y - 8, 32, 8)
    love.graphics.setColor(1,1,1,1)
end

return Monster
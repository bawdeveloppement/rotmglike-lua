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
        { class = Sprite, data = { rect = { width = 16, height = 16 }, center = true }},
        { class = CharacterComponent },
        { class = CollisionComponent },
        { class = MonsterAIComponent }
    });

    self:dropExp()
end

function Monster:dropExp()
    self:getComponent("CharacterComponent"):addOnDeath("dropxp", function ( m )
        local entities = self.world:getEntitiesByComponentName("CharacterComponent")
        local sPos = self:getComponent("TransformComponent").position -- self pos
        for i, v in ipairs(entities) do
            local vPos = v:getComponent("TransformComponent").position
            if vPos ~= nil and sPos ~= nil then
                if vPos.x > sPos.x - 100 and vPos.x < sPos.x + 100 and vPos.y > sPos.y - 100 and vPos.y < sPos.y + 100 then
                    v:getComponent("CharacterComponent"):getExp(100)
                end
            end
        end
    end)
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
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

    self.zoneRadius = 200
    self:bindDropExp()
    
    self.font = love.graphics.newFont("src/assets/fonts/yoster.ttf")
end

function Monster:bindDropExp()
    self:getComponent("CharacterComponent"):addOnDeath("dropxp", function ( m )
        local entities = self.world:getEntitiesByComponentName("CharacterComponent")
        local sPos = self:getComponent("TransformComponent").position -- self pos
        for i, v in ipairs(entities) do
            local vPos = v:getComponent("TransformComponent").position
            if vPos ~= nil and sPos ~= nil then
                if vPos.x > sPos.x - self.zoneRadius and vPos.x < sPos.x + self.zoneRadius and vPos.y > sPos.y - self.zoneRadius and vPos.y < sPos.y + self.zoneRadius then
                    if v.name ~= self.name then
                        v:getComponent("CharacterComponent"):getExp(m.max_exp)
                    end
                end
            end
        end
    end)
end

function Monster:draw()
    Entity.draw(self)local mx, my = love.mouse.getPosition()
    local position = self:getComponent("TransformComponent").position
    local rect = self:getComponent("SpriteComponent").rect
    local character = self:getComponent("CharacterComponent")

    -- if mx > position.x and mx < position.x + rect.width and my > position.y and my < position.y + rect.height then
        -- local defaultFont = love.graphics.getFont()
        -- love.graphics.setFont(self.font)
        love.graphics.setColor(1,0,0,1)
        love.graphics.rectangle("fill", position.x, position.y - 8, 32, 8)
        love.graphics.setColor(1,1,1,1)
        local text = love.graphics.newText(self.font, ""..character.level)
        love.graphics.draw(text, position.x - text:getWidth() - 2, position.y - text:getHeight())
        -- love.graphics.setFont(defaultFont)
    -- end
end

return Monster
-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local CollisionComponent = require(_G.engineDir .. "components.collision")
local Entity = require(_G.engineDir.."entity")

local MonsterAIComponent = require(_G.srcDir .. "components.monster_ai")
local CharacterComponent = require(_G.srcDir .. "components.character")
local BagEntity = require(_G.srcDir .. "entities.bag")

local Monster = require(_G.libDir .. "middleclass")("Monster", Entity)

function Monster:initialize ( world, data)
    Entity.initialize(self, world, data.name.."#"..world:getEntitiesCount(), data.name, {
        { class = Transform, data = data },
        { class = Sprite, data = { rect = { width = 16, height = 16 }, center = true }},
        { class = CharacterComponent },
        { class = CollisionComponent },
        { class = MonsterAIComponent }
    });

    self.zoneRadius = 200
    self:bindDropExp()
    self:bindDropBag()
    
    self.font = love.graphics.newFont("src/assets/fonts/yoster.ttf")
    self.dropBagSound = _G.xle.ResourcesManager:getOrAddSound("loot_appears.mp3")
end

function Monster:bindDropExp()
    self:getComponent("CharacterComponent"):addOnDeath("dropxp", function ( m )
        local entities = self.world:getEntitiesByComponentName("CharacterComponent")
        local sPos = self:getComponent("TransformComponent").position -- self pos
        for i, v in ipairs(entities) do
            local vPos = v:getComponent("TransformComponent").position
            if vPos ~= nil and sPos ~= nil then
                if vPos.x > sPos.x - self.zoneRadius and vPos.x < sPos.x + self.zoneRadius and vPos.y > sPos.y - self.zoneRadius and vPos.y < sPos.y + self.zoneRadius then
                    if m:isFriendOfByName(v.name) == false then
                        v:getComponent("CharacterComponent"):getExp(m.max_exp)
                    end
                end
            end
        end
    end)
end

function Monster:bindDropBag()
    self:getComponent("CharacterComponent"):addOnDeath("dropbag", function ( m )
        local sPos = self:getComponent("TransformComponent").position -- self pos
        if self.dropBagSound:isPlaying() then
            self.dropBagSound:stop()
            self.dropBagSound:play()
        else
            self.dropBagSound:play()
        end
        local randomBag = love.math.random(1, 18)
        self.world:addEntity(BagEntity:new(self.world, { position = sPos, name = _G.dbObject.Containers[randomBag].id }))
    end)
end

local timerToShowFoundTarget = 50

function Monster:draw()
    Entity.draw(self)local mx, my = love.mouse.getPosition()
    local position = self:getComponent("TransformComponent").position
    local rect = self:getComponent("SpriteComponent").rect
    local character = self:getComponent("CharacterComponent")

    -- love.graphics.setColor(0,0,0,0.4)
    -- love.graphics.rectangle("fill", position.x - 12, position.y - 16, 50, 16)
    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle("fill", position.x, position.y - 12, 32 * ( character.stats.life / character.stats.max_life ), 8)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line", position.x, position.y - 12, 32 * ( character.stats.life / character.stats.max_life ), 8)
    local text = love.graphics.newText(self.font, ""..character.level)
    love.graphics.draw(text, position.x - text:getWidth() - 2, position.y - text:getHeight())


end

return Monster
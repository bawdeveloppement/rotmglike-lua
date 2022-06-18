-- Components
local SpriteComponent = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local CollisionComponent = require(_G.engineDir .. "components.collision")
local Entity = require(_G.engineDir.."entity")

local MonsterAIComponent = require(_G.srcDir .. "components.component-monster_ai")
local CharacterComponent = require(_G.srcDir .. "components.component-character")
local BagEntity = require(_G.srcDir .. "entities.entity-bag")

local Monster = require(_G.libDir .. "middleclass")("Monster", Entity)

function Monster:initialize ( world, data)
    local CharacterData = _G.dbObject.getCharacter(data.name)
    self.CharacterData = CharacterData
    local spriteData = {}
    
    if CharacterData.Texture ~= nil then
        spriteData = {
            rect = { width = 32 , height= 32 },
            tile = { width = CharacterData.Texture.Size.Width or 8, height = CharacterData.Texture.Size.Height or 8 },
            image = _G.xle.ResourcesManager:getTexture(CharacterData.Texture.File),
            spriteIndex = CharacterData.Texture.Index
        }
    else
        spriteData = {
            rect = { width = 32 , height= 32 },
            tile = { width = 8, height = 8 },
            image = _G.xle.ResourcesManager:getTexture(CharacterData.AnimatedTexture.File),
            spriteIndex = CharacterData.AnimatedTexture.Index
        }
    end

    Entity.initialize(self, world, data.id or data.name.."#"..world:getEntitiesCount(), data.name, {
        { class = Transform, data = data },
        { class = SpriteComponent, data = spriteData},
        { class = CharacterComponent, data = CharacterData },
        { class = CollisionComponent, data = { rect = { width = 32, height = 32 }}},
        { class = MonsterAIComponent, data = CharacterData }
    });

    self.zoneRadius = 200
    self:bindDropExp()
    
    if CharacterData.Loots ~= nil then
        self:bindDropBag(CharacterData.Loots)
    end

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

function Monster:bindDropBag(lootIdList)
    self:getComponent("CharacterComponent"):addOnDeath("dropbag", function ( m )
        local sPos = self:getComponent("TransformComponent").position -- self pos
        if self.dropBagSound:isPlaying() then
            self.dropBagSound:stop()
            self.dropBagSound:play()
        else
            self.dropBagSound:play()
        end
        local randomBag = love.math.random(1, 18)
        local loots = {}
        
        if #lootIdList > 0 then
            local probability = love.math.random(1, 100) / 100
            for i, loot in ipairs(lootIdList) do
                if probability < loot.probability then
                    table.insert(loots, #loots + 1, _G.dbObject.createEquipementById(loot.id))
                end
            end
        end

        if #loots > 0 then
            self.world:addEntity(BagEntity:new(self.world, {
                position = sPos,
                name = _G.dbObject.Containers[randomBag].id,
                items = loots
            }))
        end
    end)
end

local timerToShowFoundTarget = 50

function Monster:draw()
    Entity.draw(self)
    
    local mx, my = love.mouse.getPosition()
    local position = self:getComponent("TransformComponent").position
    local rect = self:getComponent("SpriteComponent").rect
    local character = self:getComponent("CharacterComponent")

    -- love.graphics.setColor(0,0,0,0.4)
    -- love.graphics.rectangle("fill", position.x - 12, position.y - 16, 50, 16)
    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle("fill", position.x, position.y - 12, 32 * ( character.stats.life / character.stats.max_life.base ), 8)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line", position.x, position.y - 12, 32 * ( character.stats.life / character.stats.max_life.base ), 8)
    local text = love.graphics.newText(self.font, ""..character.level)
    love.graphics.draw(text, position.x - text:getWidth() - 2, position.y - text:getHeight())


end

return Monster
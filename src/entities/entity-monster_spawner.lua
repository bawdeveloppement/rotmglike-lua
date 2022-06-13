-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local Entity = require(_G.engineDir.."entity")

local Monster = require(_G.srcDir .. "entities.entity-monster")
local MonsterSpawner = require(_G.libDir .. "middleclass")("MonsterSpawner", Entity)

function MonsterSpawner:initialize ( world, data )
    Entity.initialize(self, world, "MonsterSpawner1", "MonsterSpawner", {
        { class = Transform, data = { position = data.position  }},
        { class = Sprite, data = { width = 32, height = 32, center = true }},
    });
    self.entityToSpawn = data.name
    self.spawnMonsterTimer = 100;
    self.monsterKilled = 0;
    self.active = false
end

function MonsterSpawner:update(...)
    Entity.update(self, ...)
    
    local dt = ...
    local monsters = self.world:getEntitiesByComponentName("MonsterAIComponent")
    local selfPosition = self:getComponent("TransformComponent").position;
    

    -- DetectArea
    local searchPlayerResult = self.world:getEntitiesByComponentName("PlayerComponent")
    local playerInAreaCount = 0
    if #searchPlayerResult > 0 then
        for i, v in ipairs(searchPlayerResult) do
            local playerPosition = v:getComponent("TransformComponent").position;
            if playerPosition.x < selfPosition.x + 200 and playerPosition.x > selfPosition.x - 200 and playerPosition.y < selfPosition.y + 200 and playerPosition.y > selfPosition.y - 200 then 
                playerInAreaCount = playerInAreaCount + 1
            end
        end
    end

    self.active = playerInAreaCount > 0
    
    if self.active ~= false then
        if #monsters < 5 and self.monsterKilled < 3 then
            if self.spawnMonsterTimer < 1 then
                local position = self:getComponent("TransformComponent").position
                self.world:addEntity( Monster:new(self.world, { name = self.entityToSpawn, position = position }) )
                self.spawnMonsterTimer = 100
            else
                self.spawnMonsterTimer = self.spawnMonsterTimer - 1
            end
        end
    end

end

return MonsterSpawner
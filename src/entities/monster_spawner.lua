-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local Entity = require(_G.engineDir.."entity")

local Monster = require(_G.srcDir .. "entities.monster")
local MonsterSpawner = require(_G.libDir .. "middleclass")("MonsterSpawner", Entity)

function MonsterSpawner:initialize ( world, data )
    Entity.initialize(self, world, "MonsterSpawner", {
        { class = Transform, data = { position = data.position  }},
        { class = Sprite, data = { width = 32, height = 32, center = true }},
    });
    self.entityToSpawn = data.name
    self.spawnMonsterTimer = 100;
    self.monsterKilled = 0;
end

function MonsterSpawner:update(dt)
    Entity.update(self, dt)
    
    local monsters = self.world:getEntitiesByComponent("MonsterAIComponent")

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

return MonsterSpawner
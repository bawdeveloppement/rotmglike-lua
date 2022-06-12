local System = require(_G.engineDir .. "system");
local WorldBossSystem = require(_G.libDir .. "middleclass")("WorldBossSystem")

function WorldBossSystem:initialize( world )
    System.initialize(self, world)

    
    self.nextWorldBossTimer = 100
    self.currentWorldBossTimer = self.nextWorldBossTimer
    self.worldBossList = { "boss1", "boss2" }
    self.worldBossDefeated = {}
    self.currentWorldBoss = nil
end

function WorldBossSystem:update(dt)
    if self.currentWorldBossTimer > 0 then
        self.currentWorldBossTimer = self.currentWorldBossTimer - dt
    end
    
    if self.currentWorldBossTimer < 0 and self.currentWorldBoss == nil then
        self.currentWorldBoss = self.worldBossList[1]
        table.remove(self.worldBossList, 1)
    end

    if self.currentWorldBoss ~= nil then
        local entity = self.world:getEntityById(currentWorldBoss)
        if entity == nil then 
        self.currentWorldBoss = nil
        self.currentWorldBossTimer = self.nextWorldBossTimer
        end
    end
end

function WorldBossSystem:draw()
    -- Get current pos of the current boss
    local currentBoss = {
        x = 400,
        y = 400
    }

    local camera = {
        x = 0,
        y = 0,
        width = 800,
        height = 600 
    }

    searchPlayer = self.world:getEntitiesByComponentName("PlayerComponent")

    if #searchPlayer > 0 then
        local playerPosition = searchPlayer[1]:getComponent("TransformComponent").position
        local rect = {
            x = 0,
            y = 0
        }

        if not (currentBoss.x > playerPosition.x - camera.width / 2 and currentBoss.x < playerPosition.x + camera.width / 2 and currentBoss.y > playerPosition.y - camera.height / 2 and currentBoss.y < playerPosition.y + camera.height / 2) then
            -- rect.x = currentBoss.x
            print((currentBoss.x > playerPosition.x - camera.width / 2 and currentBoss.x < playerPosition.x + camera.width / 2 and currentBoss.y > playerPosition.y - camera.height / 2 and currentBoss.y < playerPosition.y + camera.height / 2))
            if currentBoss.x > playerPosition.x + camera.width / 2 then
                rect.x = playerPosition.x + camera.width / 2
            elseif currentBoss.x < playerPosition.x - camera.width / 2 then
                rect.x = playerPosition.x - camera.width / 2
            else
                rect.x = currentBoss.x
            end

            if currentBoss.y > playerPosition.y + camera.height / 2 then
                rect.y = playerPosition.y + camera.height / 2
            elseif currentBoss.y < playerPosition.y - camera.height / 2 then
                rect.y = playerPosition.y - camera.height / 2
            else
                rect.y = currentBoss.y
            end
            love.graphics.rectangle("line", rect.x, rect.y, 100, 20)
        end
    end
end

return WorldBossSystem
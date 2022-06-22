local System = require(_G.engineDir .. "system");
local WorldBossSystem = require(_G.libDir .. "middleclass")("WorldBossSystem")
local MonsterEntity = require(_G.srcDir .. "entities.entity-monster")

WorldBossSystem.static.name = WorldBossSystem

function WorldBossSystem:initialize( world )
    System.initialize(self, world)

    
    self.nextWorldBossTimer = 1
    self.currentWorldBossTimer = self.nextWorldBossTimer
    self.worldBossList = { "Classic Ghost" }
    self.worldBossDefeated = {}
    self.currentWorldBoss = nil
end

function WorldBossSystem:update(dt)
    if self.currentWorldBossTimer > 0 then
        self.currentWorldBossTimer = self.currentWorldBossTimer - dt
    end


    if self.currentWorldBossTimer < 0 and self.currentWorldBoss == nil and #self.worldBossList > 0 then
        self.currentWorldBoss = self.worldBossList[1] .. "#event"
        self.world:addEntity(MonsterEntity:new(self.world, { id= self.worldBossList[1] .. "#event", name = self.worldBossList[1], position = { x= 400, y = 400} }) )
        table.remove(self.worldBossList, 1)
    end

    if self.currentWorldBoss ~= nil then
        local entity = self.world:getEntityById(self.currentWorldBoss)
        if entity == nil then 
            self.currentWorldBoss = nil
            self.currentWorldBossTimer = self.nextWorldBossTimer
        end
    end
end

function WorldBossSystem:draw()
    -- Get current pos of the current boss
    local camera = {
        width = 800,
        height = 600
    }
    
    if self.currentWorldBoss ~= nil then
        local entity = self.world:getEntityById(self.currentWorldBoss)
        if entity then
            local currentBossPositionWorld = entity:getComponent("TransformComponent").position;
        
            searchPlayer = self.world:getEntitiesByComponentName("PlayerComponent")
    
            if #searchPlayer > 0 then
                local playerPositions = searchPlayer[1]:getComponent("TransformComponent").position
                
                local bx, by = _G.camera:cameraCoords(currentBossPositionWorld.x, currentBossPositionWorld.y)
                
                local px, py = _G.camera:cameraCoords(playerPositions.x, playerPositions.y)
                
                local rect = {
                    x = 0,
                    y = 0
                }
    
                if not (bx > px - camera.width / 2 and bx < px + camera.width / 2 and by > py - camera.height / 2 and by < py + camera.height / 2) then
                    -- rect.x = bx
                    if bx > px + camera.width / 2 then
                        rect.x = px + camera.width / 2 - 100
                    elseif bx < px - camera.width / 2 then
                        rect.x = px - camera.width / 2
                    else
                        rect.x = bx
                    end
    
                    if by > py + camera.height / 2 then
                        rect.y = py + camera.height / 2 - 50
                    elseif by < py - camera.height / 2 then
                        rect.y = py - camera.height / 2 + 60
                    else
                        rect.y = by
                    end
                    love.graphics.rectangle("line", rect.x, rect.y, 100, 20)
                    love.graphics.print(entity.name, rect.x + 10, rect.y)
                    local sprite = entity:getComponent("SpriteComponent")
                    love.graphics.draw(sprite.image, sprite:getSpriteIndex(sprite.spriteIndex), rect.x + 50 - 16, rect.y - 42, sprite.orientation, sprite.scale);
                    love.graphics.rectangle("line", rect.x + 50 - 16, rect.y - 44, 36, 36)
                    
                end
            end
        end
    end
end

return WorldBossSystem
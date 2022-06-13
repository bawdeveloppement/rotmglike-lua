local System = require(_G.engineDir .. "system");
local CameraSystem = require(_G.libDir .. "middleclass")("CameraSystem")
local MonsterEntity = require(_G.srcDir .. "entities.entity-monster")

function CameraSystem:initialize( world )
    System.initialize(self, world)
end

function CameraSystem:update(dt)
    local searchPlayer = self.world:getEntitiesByComponentName("PlayerComponent")
    if #searchPlayer > 0 then
        local playerPosition = searchPlayer[1]:getComponent("TransformComponent").position
        self.world.origin = playerPosition
    end
end

return CameraSystem
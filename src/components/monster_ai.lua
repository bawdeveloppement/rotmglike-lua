local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

local Projectile = require(_G.srcDir .. "entities.projectile");
-- Create a class called "MonsterAI" and inherit of Component
local MonsterAIComponent = Class("MonsterAIComponent", Component);

MonsterAIComponent.static.name = "MonsterAIComponent"

function MonsterAIComponent:initialize( entity )
    Component.initialize(self, entity)
    self.name = "MonsterAIComponent";


    self.velocity = {
        x = 0,
        y = 0
    }
    
    self.sound = {
        death = love.audio.newSource("src/assets/sfx/monster/".. self.entity.name .."s_death.mp3", "static"),
        hit = love.audio.newSource("src/assets/sfx/monster/".. self.entity.name .."s_hit.mp3", "static"),
        fire = love.audio.newSource("src/assets/sfx/arrowShoot.mp3", "static")
    }

    self.attack = {
        cooldown = love.math.random(80, 100)
    }
end

function MonsterAIComponent:update()
    local position = self:getComponent("TransformComponent").position
    local characters = self.entity.world:getEntitiesByComponent("CharacterComponent")

    if characters[1] ~= nil then
        local playerPos = characters[1]:getComponent("TransformComponent").position
        local velx = math.cos(math.atan2(position.y - playerPos.y, position.x - playerPos.x))
        local vely = math.sin(math.atan2(position.y - playerPos.y, position.x - playerPos.x));
        -- body
        self.velocity.x = velx
        self.velocity.y = vely
        -- if position.isInCollision == false then 
            position.x = position.x - self.velocity.x * 1
            position.y = position.y - self.velocity.y * 1
        -- end
    end

    self.attack.cooldown = self.attack.cooldown - 1;
    -- if monsters[i].x + monsters[i].w >= player.x and monsters[i].x <= player.x + player.w
    -- and monsters[i].y + monsters[i].h >= player.y and monsters[i].y <= player.y + player.h
    -- then
    --     monsters[i].isInCollision = true
        if self.attack.cooldown <= 0 then
            -- player.stats.life = player.stats.life - monsters[i].attack.damage;
            self.world:addEntity( Projectile:new(self.world, { x = position.x, y = position.y, dx, dy}))
            self.sound.fire.play(self.sound.fire)
            self.attack.cooldown = love.math.random(80, 100)
        end
    -- else
    --     monsters[i].isInCollision = false
    -- end
end


return MonsterAIComponent
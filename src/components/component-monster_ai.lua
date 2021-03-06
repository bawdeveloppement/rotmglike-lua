local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

local Projectile = require(_G.srcDir .. "entities.entity-projectile");
-- Create a class called "MonsterAI" and inherit of Component
local MonsterAIComponent = Class("MonsterAIComponent", Component);

MonsterAIComponent.static.name = "MonsterAIComponent"

function MonsterAIComponent:initialize( entity, data )
    Component.initialize(self, entity)
    self.name = "MonsterAIComponent";

    self.velocity = {
        x = 0,
        y = 0
    }

    self.sound = {
        death = _G.xle.ResourcesManager:getOrAddSound("monster/".. self.entity.name .."s_death.mp3"),
        hit =   _G.xle.ResourcesManager:getOrAddSound("monster/".. self.entity.name .."s_hit.mp3"),
        fire =  _G.xle.ResourcesManager:getOrAddSound("arrowShoot.mp3")
    }

    self.projectileData = data.Projectile

    self.attack = {
        cooldown = love.math.random(80, 100) - ( self.entity:getComponent("CharacterComponent").stats.dexterity.base * 2 or 0 ),
        distance = 100,
        damage = love.math.random(10, 30) + ( self.entity:getComponent("CharacterComponent").stats.attack.base or 0 )
    }
end

function MonsterAIComponent:update(...)
    local position = self:getComponent("TransformComponent").position
    local characters = self.entity.world:getEntitiesByComponentName("CharacterComponent")
    local target = nil
    for i, v in ipairs(characters) do
        local vPos = v:getComponent("TransformComponent").position
        if vPos.x > position.x - 200 and vPos.x < position.x + 200 and vPos.y > position.y - 200 and vPos.y < position.y + 200 then
            local vChar = v:getComponent("CharacterComponent")
            if vChar.isPlayer then
                local velx = math.cos(math.atan2(position.y - vPos.y, position.x - vPos.x))
                local vely = math.sin(math.atan2(position.y - vPos.y, position.x - vPos.x));
                -- body
                self.velocity.x = velx
                self.velocity.y = vely
                -- target velx
                target = {
                    x = velx,
                    y = vely
                }
                -- if position.isInCollision == false then 
                position.x = position.x - self.velocity.x * 1
                position.y = position.y - self.velocity.y * 1
            end
        end
    end

    self.attack.cooldown = self.attack.cooldown - 1;
    if self.attack.cooldown <= 0 and target ~= nil then
        self.entity.world:addEntity( Projectile:new(self.entity.world, {
            ownerId = self.entity.id,
            projectileId = self.projectileData.ObjectId,
            damage = {
                minDamage = self.projectileData.MinDamage,
                maxDamage = self.projectileData.MaxDamage
            },
            lifeTimeMs = self.projectileData.LifetimeMS,
            speed = self.projectileData.Speed,
            x = position.x,
            y = position.y,
            dx = self.velocity.x,
            dy = self.velocity.y,
        }))
        self.sound.fire.play(self.sound.fire)
        self.attack.cooldown = love.math.random(80, 100)
    end
end


return MonsterAIComponent
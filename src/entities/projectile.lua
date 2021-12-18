local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir .. "components.transform")
local CollisionComponent = require(_G.srcDir .. "components.collision")
local Sprite = require(_G.engineDir .. "components.sprite")
local Projectile = require(_G.libDir .. "middleclass")("Projectile", Entity);

function Projectile:initialize( world, data )
    Entity.initialize(self, world, "Projectile"..world:getEntitiesCount(), "Projectile", {
        { class = TransformComponent, data = { position = { x = data.x, y = data.y }}},
        { class = Sprite, data = { width = 32, height = 32 }},
        { class = CollisionComponent, data = { rect = { width = 32, height = 32 }}}
    });

    self.ownerId = data.ownerId or nil

    self.attack = data.attack or {
        distance = 300,
        damage = love.math.random(10, 30)
    }

    self.start = {
        x = data.x,
        y = data.y
    }

    self.dx = data.dx
    self.dy = data.dy
end

function Projectile:update()
    local position = self.components["TransformComponent"].position
    local rect = self.components["CollisionComponent"].rect
    position.x = position.x - self.dx * 10
    position.y = position.y - self.dy * 10

    local searchPlayerResult = self.world:getEntitiesWithAtLeast({ "TransformComponent", "CharacterComponent" })
    if searchPlayerResult[1] ~= nil then
        local playerPosition = searchPlayerResult[1]:getComponent("TransformComponent").position
        local playerRect = searchPlayerResult[1]:getComponent("SpriteComponent").rect
        if position.x + rect.width > playerPosition.x and position.x < playerPosition.x + playerRect.width and
        position.y + rect.height > playerPosition.y and position.y < playerPosition.y + playerRect.height then
            searchPlayerResult[1]:getComponent("CharacterComponent"):getDamage(10)
            self.markDestroy = true
        end
    end

    -- TODO:Remove projectiles after distance
    local longAB = function ( field ) return (position[field] - self.start[field]) * (position[field] - self.start[field]) end
    local longueur = math.sqrt(longAB("x") + longAB("y"))
    if longueur > self.attack.distance then
        print("dazdaz")
        self.markDestroy = true
    end
end

function Projectile:draw()
    Entity.draw(self)
    -- if Settings.drawDebug == true then
        -- 
    -- end
end

return Projectile
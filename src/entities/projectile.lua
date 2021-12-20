local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir .. "components.transform")
local CollisionComponent = require(_G.srcDir .. "components.collision")
local Sprite = require(_G.engineDir .. "components.sprite")
local Projectile = require(_G.libDir .. "middleclass")("Projectile", Entity);

function Projectile:initialize( world, data )
    Entity.initialize(self, world, "Projectile"..world:getEntitiesCount(), "Projectile", {
        { class = TransformComponent, data = { position = { x = data.x, y = data.y }}},
        { class = Sprite, data = { rect = { width = 16, height = 16 }}},
        { class = CollisionComponent, data = { solid = true, rect = { width = 16, height = 16 }}}
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

    local searchPlayerResult = self.world:getEntitiesWithAtLeast({ "CollisionComponent", "CharacterComponent" })
    for i, v in ipairs(searchPlayerResult) do
        local vPosition = v:getComponent("TransformComponent").position
        local vRect = v:getComponent("SpriteComponent").rect
        local vChar = v:getComponent("SpriteComponent").rect
        local sChar = v:getComponent("SpriteComponent").rect
        if (position.x + rect.width > vPosition.x and position.x < vPosition.x + vRect.width and
            position.y + rect.height > vPosition.y and position.y < vPosition.y + vRect.height) and v.id ~= self.ownerId
            then
                local owner = self.world:getEntityById(self.ownerId);
                if owner ~= nil then
                    if v.name ~= owner.name then
                        v:getComponent("CharacterComponent"):getDamage(10, self.ownerId)
                        self.markDestroy = true
                    end
                end
        end
    end
    -- Remove projectiles after distance
    local longAB = function ( field ) return (position[field] - self.start[field]) * (position[field] - self.start[field]) end
    local longueur = math.sqrt(longAB("x") + longAB("y"))
    if longueur > self.attack.distance then
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
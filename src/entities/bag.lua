-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")
local SpriteComponent = require(_G.engineDir.."components.sprite")
local CollisionComponent = require(_G.engineDir.."components.collision")

local BagEntity = require(_G.libDir .. "middleclass")("BagEntity", Entity)

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
 end


function BagEntity:initialize( world, data )
    Entity.initialize(self,
        world,
        "Bag",
        data.name or "Loot Bag 2",
        {
            { class = TransformComponent, data = { position = data.position } },
            { class = SpriteComponent, data = { rect = { width = 16, height = 16 }, scale = 2, center = true }},
            { class = CollisionComponent },
        }
    )

    self.slots = {}
    for i, v in ipairs(_G.dbObject["Containers"]) do
        if v["$"].id == self.name then
            self:getComponent("SpriteComponent"):setImage(_G.xle.ResourcesManager:getTexture(v["Texture"].File))
            self:getComponent("SpriteComponent"):setIndex(tonumber(v["Texture"].Index, 16))
        end
    end

    self.lifeTimer = 1000
end


function BagEntity:update()
    Entity.draw(self)

    self.lifeTimer = self.lifeTimer - 1
    if self.lifeTimer <= 0 then
        self.markDestroy = true
    end
end

function BagEntity:draw()
    Entity.draw(self)
end

function BagEntity:mousepressed(mx, my, button)
end

function BagEntity:mousereleased(mx, my, button)
end

return BagEntity

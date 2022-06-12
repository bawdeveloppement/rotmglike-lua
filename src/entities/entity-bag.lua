-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")
local SpriteComponent = require(_G.engineDir.."components.sprite")
local CollisionComponent = require(_G.engineDir.."components.collision")
local ContainerComponent = require(_G.srcDir .. "components.component-container")

local BagEntity = require(_G.libDir .. "middleclass")("BagEntity", Entity)

local SlotGameObject = require(_G.srcDir .. "go.go-slot")

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
            { class = TransformComponent, data = { position = data.position }},
            { class = SpriteComponent, data = { rect = { width = 16, height = 16 }, scale = 2, center = true }},
            { class = CollisionComponent, data = { rect = { width = 16, height = 16 }}},
            { class = ContainerComponent, data = { items = data.items }}
        }

        
    )
    
    self.alreadySetItems = false

    self.items = data.items
    
    self.slots = {}
    if #data.items > 0 then
        for i, v in ipairs(self.items) do
            table.insert(self.slots, #self.slots + 1, SlotGameObject:new(data.position, v, 1))
        end
    end

    for i, v in ipairs(_G.dbObject["Containers"]) do
        if v.id == self.name then
            self:getComponent("SpriteComponent"):setImage(_G.xle.ResourcesManager:getTexture(v["Texture"].File))
            self:getComponent("SpriteComponent"):setIndex(v["Texture"].Index)
        end
    end

    self.lifeTimer = 1000
end


function BagEntity:update(...)
    Entity.draw(self, ...)

    self.lifeTimer = self.lifeTimer - 1
    if self.lifeTimer <= 0 then
        self.markDestroy = true
    end
end

function BagEntity:draw()
    Entity.draw(self)

    
    for i, v in ipairs(self.slots) do
        v:draw()
    end
end

function BagEntity:mousepressed(mx, my, button)
end

function BagEntity:mousereleased(mx, my, button)
end

return BagEntity


-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")
local SpriteComponent = require(_G.engineDir.."components.sprite")
local CollisionComponent = require(_G.engineDir.."components.collision")
local ContainerComponent = require(_G.srcDir .. "components.component-container")

local BagEntity = require(_G.libDir .. "middleclass")("BagEntity", Entity)

local SlotGameObject = require(_G.srcDir .. "prefabs.prefab-slot")


function BagEntity:initialize( world, data )
    Entity.initialize(self,
        world,
        "Bag",
        data.name,
        {
            { class = TransformComponent, data = { position = data.position }},
            { class = SpriteComponent, data = { rect = { width = 16, height = 16 }, scale = 2, center = true }},
            { class = CollisionComponent, data = { rect = { width = 16, height = 16 }}},
        }
    )
    
end


function BagEntity:update(...)
    Entity.draw(self, ...)
end

function BagEntity:draw()
    Entity.draw(self)
end

return BagEntity


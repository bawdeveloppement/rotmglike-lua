-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")
local SpriteComponent = require(_G.engineDir.."components.sprite")

local BagUIComponent = require(_G.srcDir.."components.bagui")

local BagEntity = require(_G.libDir .. "middleclass")("BagEntity", Entity)

function BagEntity:initialize( parent, data )
    Entity.initialize(
        parent,
        "Bag",
        "Bag",
        {
            { class = TransformComponent },
            { class = SpriteComponent, data = { width = 32, height = 32, center = true }},
            { class = BagUIComponent }
        }
    )
end

return BagEntity

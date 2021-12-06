-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")

local DrawableRectComponent = require(_G.srcDir.."components.drawablerect")
local BagUIComponent = require(_G.srcDir.."components.bagui")

return Entity:new(
    "Bag",
    {
        { class = TransformComponent },
        { class = DrawableRectComponent, data = { width = 32, height = 32, center = true }},
        { class = BagUIComponent }
    }
)
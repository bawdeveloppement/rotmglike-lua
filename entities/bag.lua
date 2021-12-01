-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")

local MoveComponent = require(_G.baseDir.."components.move")
local DrawableRectComponent = require(_G.baseDir.."components.drawablerect")
local BagUIComponent = require(_G.baseDir.."components.bagui")


return Entity:new(
    "Bag",
    {
        { class = TransformComponent },
        { class = DrawableRectComponent, data = { width = 32, height = 32, center = true }},
        { class = BagUIComponent }
    }
)
-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local Entity = require(_G.engineDir.."entity")

local Bat = require(_G.engineDir .. "middleclass")("Bat", Entity)

local DrawableRectComponent = require(_G.baseDir.."components.drawablerect")

function Bat:initialize ()
    Entity.initialize(self, "Bat", {
        { class = Transform },
        { class = DrawableRectComponent, data = { width = 32, height = 32, center = true }},
    })
end

return Bat
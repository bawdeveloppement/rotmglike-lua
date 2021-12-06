-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local Entity = require(_G.engineDir.."entity")

local LifeHUD = require(_G.libDir .. "middleclass")("LifeHUD", Entity)

function LifeHUD:initialize (data)
    Entity.initialize(self, "LifeHUD", {
        { class = Transform, data = data },
        { class = Sprite, data = { width = 32, height = 32, center = true }},
    });
end

function LifeHUD:update()
end

return LifeHUD
-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local Entity = require(_G.engineDir.."entity")

local Monster = require(_G.engineDir .. "middleclass")("Monster", Entity)

function Monster:initialize ()
    Entity.initialize(self, "Monster", {
        { class = Transform },
        { class = Sprite, data = { width = 32, height = 32, center = true }},
        { class = MonsterAI, data = { id="bat" }},
    })
end

return Monster
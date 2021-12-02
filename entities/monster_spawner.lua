-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local Entity = require(_G.engineDir.."entity")

local MonsterSpawner = require(_G.engineDir .. "middleclass")("MonsterSpawner", Entity)

local DrawableRectComponent = require(_G.baseDir.."components.drawablerect")

function MonsterSpawner:initialize ()
    Entity.initialize(self, "MonsterSpawner", {
        { class = Transform, data = { x = 400 } },
        { class = DrawableRectComponent, data = { width = 32, height = 32, center = true }},
    })
end

return MonsterSpawner
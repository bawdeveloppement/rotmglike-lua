-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local Entity = require(_G.engineDir.."entity")

local MonsterSpawner = require(_G.libDir .. "middleclass")("MonsterSpawner", Entity)


function MonsterSpawner:initialize ()
    Entity.initialize(self, "MonsterSpawner", {
        { class = Transform, data = { x = 400 } },
        { class = Sprite, data = { width = 32, height = 32, center = true }},
    });
end

return MonsterSpawner
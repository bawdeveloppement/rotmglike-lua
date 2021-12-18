-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local Entity = require(_G.engineDir.."entity")

local MonsterAIComponent = require(_G.srcDir .. "components.monster_ai")

local Monster = require(_G.libDir .. "middleclass")("Monster", Entity)

function Monster:initialize ( world, data)
    Entity.initialize(self, world, "Monster", data.name, {
        { class = Transform, data = data },
        { class = Sprite, data = { width = 32, height = 32, center = true }},
        { class = MonsterAIComponent }
    });
end


return Monster
-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local Entity = require(_G.engineDir.."entity")

local CharacterHUD = require(_G.libDir .. "middleclass")("CharacterHUD", Entity)

function CharacterHUD:initialize (data)
    Entity.initialize(self, "CharacterHUD", {
        { class = Transform, data = data },
        { class = Sprite, data = { width = 32, height = 32, center = true }},
    });
end

return CharacterHUD
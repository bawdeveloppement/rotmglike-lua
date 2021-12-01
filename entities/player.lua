-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")

local Player = require(_G.engineDir .. "middleclass")("Player", Entity)

function Player:initialize ()
    self.initialize()
end
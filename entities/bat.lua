-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")

local Bat = require(_G.engineDir .. "middleclass")("Bat", Entity)

function Bat:initialize ()
    self.initialize()
end
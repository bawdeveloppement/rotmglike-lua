local Screen = require(_G.engineDir .. "screen")

local EngineScreen = require(_G.libDir .. "middleclass")("EngineScreen",Screen)

function EngineScreen:new()
    Screen.initialize(self, "EngineScreen")
end

return EngineScreen
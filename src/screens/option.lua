local GameOptionScreen = require(_G.libDir .. "middleclass")("GameOptionScreen", _G.xle.Screen)

function GameOptionScreen:initialize (name, active)
    _G.xle.Screen.initialize(self, name, active)
end

return GameOptionScreen;
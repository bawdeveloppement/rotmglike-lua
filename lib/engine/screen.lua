
local Screen = require(_G.libDir .. "middleclass")("Screen")

Screen.static.screensInstances = {}

function Screen:initialize( name )
    self.active = false
    table.insert(Screen.screensInstances, #Screen.screensInstances + 1, self)
end

return Screen
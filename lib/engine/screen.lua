
local Screen = require(_G.libDir .. "middleclass")("Screen")

Screen.static.screensInstances = {}

function Screen:initialize( name, active, entities )
    self.active = active
    self.name = name
    
    table.insert(Screen.screensInstances, #Screen.screensInstances + 1, self)
end

function Screen:init()
    self.active = true
    love.window.setTitle(self.name)
end

Screen.static.goToScreen = function ( name )
    -- current screen activate
    for i, v in ipairs(Screen.screensInstances) do
        if v.active and v.name ~= name then
            Screen.screensInstances[i].active = false
        end
    end
    -- new screen to activate
    for i, v in ipairs(Screen.screensInstances) do
        if v.name == name then
            Screen.screensInstances[i].active = true
            _G.xleInstance:load()
        end
    end
end

return Screen
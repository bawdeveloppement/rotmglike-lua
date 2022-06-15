
local Scene = require(_G.libDir .. "middleclass")("Scene")

Scene.static.scenesInstances = {}

function Scene:initialize( name, active, entities )
    self.active = active
    self.name = name
    
    table.insert(Scene.scenesInstances, #Scene.scenesInstances + 1, self)
end

function Scene:init()
    self.active = true
    love.window.setTitle(self.name)
end

Scene.static.goToScene = function ( name )
    -- current screen activate
    for i, v in ipairs(Scene.scenesInstances) do
        if v.active and v.name ~= name then
            Scene.scenesInstances[i].active = false
        end
    end
    -- new screen to activate
    for i, v in ipairs(Scene.scenesInstances) do
        if v.name == name then
            Scene.scenesInstances[i].active = true
            _G.xleInstance:load()
        end
    end
end

return Scene
local XLE = require(_G.libDir .. "middleclass")("God")

local Screen = require(_G.engineDir .. "screen")
local Entity = require(_G.engineDir .. "entity")
local World = require(_G.engineDir .. "world")


function XLE:initialize( screens )
    -- require and initialise
    for i, v in ipairs(screens) do
        -- if Screen.screensInstances[v.name] == nil then
            print(v.name)
            require("src.screens."..v.name):new(v.name, v.buildIndex == 1)
        -- end
    end
    print(#screens)
    for k, v in ipairs(Screen.screensInstances) do
        print(v)
        -- require("src.screens."..v.name)(v.name, v.buildIndex == 1)
    end
end

return {
    Init = XLE,
    Entity = Entity,
    Screen = Screen,
    World = World,
}
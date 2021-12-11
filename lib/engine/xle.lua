local XLE = require(_G.libDir .. "middleclass")("God")

local Screen = require(_G.engineDir .. "screen")
local Entity = require(_G.engineDir .. "entity")
local World = require(_G.engineDir .. "world")


function XLE:initialize( screens )
    -- require and initialise
    for i, v in ipairs(screens) do
        require("src.screens."..v.name):new(v.name, v.buildIndex == 1 )
    end

    self:load()
end

function XLE:load()
    for k, v in ipairs(Screen.screensInstances) do
        if v.active then
            v:init()
        end
    end
    
    for _, v in ipairs(_G.callbacks.supported) do
        love[v] = function (...)
            for _, screen in pairs(Screen.screensInstances) do
                if screen[v] ~= nil and type(screen[v]) == "function" and screen.active then
                    screen[v](screen, ...)
                end
            end
        end
    end
end


return {
    Init = XLE,
    Entity = Entity,
    Screen = Screen,
    World = World,
}
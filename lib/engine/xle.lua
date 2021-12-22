local XLE = require(_G.libDir .. "middleclass")("God")

local Screen = require(_G.engineDir .. "screen")
local Entity = require(_G.engineDir .. "entity")
local World = require(_G.engineDir .. "world")
local ResourcesManager = require(_G.engineDir .. "resources_manager")
local callbacks = {
    all = {
        "directorydropped",
        "displayrotated",
        "errhand",
        "errorhandler",
        "filedropped",
        "focus",
        "gamepadaxis",
        "gamepadpressed",
        "gamepadrelease",
        "joystickadded",
        "joystickaxis",
        "joystickhat",
        "joystickpresse",
        "joystickrelease",
        "joystickremove",
        "load",
        "lowmemory",
        "quit",
        "textedited",
        "textinput",
        "threaderror",
        "touchmoved",
        "touchpressed",
        "touchreleased",
        "visible",
    },
    supported = {
        "wheelmoved",
        "mousefocus",
        "mousemoved",
        "mousepressed",
        "mousereleased",
        "update",
        "load",
        "draw",
        "keypressed",
        "keyreleased",
        "resize",
    }
}

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
    local w, h = love.window.getMode()
    self.old = {
        screen = {
            w = w,
            h = h
        }
    }
    for _, v in ipairs(callbacks.supported) do
        love[v] = function (...)
            if v == "keypressed" then
                local key = ...
                if key == "f" then
                    local w, h, flags = love.window.getMode()
                    self.old.screen.w = w
                    self.old.screen.h = h
                    -- print(love.window.getDesktopDimensions())
                    for i, modes in ipairs(love.window.getFullscreenModes()) do
                        print(i)
                        for k, mode in pairs(modes) do
                            print(k .. mode)
                        end
                    end
                end
            end
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
    callbacks = callbacks,
    ResourcesManager = ResourcesManager:new(),
}
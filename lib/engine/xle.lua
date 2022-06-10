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
        "conf",
        "load",
        "draw",
        "keypressed",
        "keyreleased",
        "resize",
    }
}

XLE.static.optionsCached = {}

function XLE:initialize(gameName, screens )
    self.game_name = gameName
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
            if v == "conf" then
                print(...)
            end
            if v == "load" then
                self:initGameDirectory()
                for i, mode in ipairs(love.window.getFullscreenModes()) do
                    table.insert(XLE.optionsCached, #XLE.optionsCached + 1, {id = mode.width.. "x".. mode.height, text =  mode.width.. "x".. mode.height, value = mode  })
                end
            end
            for _, screen in pairs(Screen.screensInstances) do
                if screen[v] ~= nil and type(screen[v]) == "function" and screen.active then
                    screen[v](screen, ...)
                end
            end
            if v == "draw" then
                love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,10)
            end
        end
    end
end

function XLE:initGameDirectory ()
    love.filesystem.setIdentity(self.game_name, true)

    -- print("user directory"..love.filesystem.getSaveDirectory())

    if love.filesystem.getInfo(love.filesystem.getSaveDirectory(), "directory") == nil then
        local success = love.filesystem.createDirectory(love.filesystem.getSaveDirectory())
        if success then
            print("game directory created")
        else
            print("game directory already exist")
        end
    end

    local game_path = love.filesystem.getSaveDirectory()
end


return {
    Init = XLE,
    Entity = Entity,
    Screen = Screen,
    World = World,
    callbacks = callbacks,
    ResourcesManager = ResourcesManager:new(),
}
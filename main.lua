_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.libDir    = _G.baseDir .. "lib."
_G.engineDir    = _G.libDir .. "engine."
_G.srcDir    = _G.baseDir .. "src."
_G.callbacks = {
    all = {
        "directorydropped",
        "displayrotated",
        "draw",
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
        "keypressed",
        "keyreleased",
        "load",
        "lowmemory",
        "mousefocus",
        "mousemoved",
        "mousepressed",
        "mousereleased",
        "quit",
        "resize",
        "textedited",
        "textinput",
        "threaderror",
        "touchmoved",
        "touchpressed",
        "touchreleased",
        "update",
        "visible",
        "wheelmoved",
    },
    supported = {
        "update",
        "load",
        "draw",
        "keypressed"
    }
}

love.graphics.setDefaultFilter("nearest")


local Map = require("lib.engine.tiledmap")
local map = Map:new("nexus")

local player = require("src.entities.player"):new()
local camera = {
    x = 0,
    y = 0
}

_G.cam = require("lib.camera")()

function love.update ()
    player:update()

    cam:lookAt(player:getComponent("Transform").position.x, player:getComponent("Transform").position.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w/2 then
        cam.x = w/2
    end

    -- Right border
    if cam.y < h/2 then
        cam.y = h/2
    end

    -- Get width/height of background
    local mapW = map.mapData.width * map.mapData.tilewidth * map.scale
    local mapH = map.mapData.height * map.mapData.tileheight * map.scale

    -- Right border
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end
    -- Bottom border
    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end

function love.draw ()
    cam:attach()
        map:draw()
        player:draw()
    cam:detach()
end


function love.keypressed ()
    cam:attach()
        map:draw()
        player:draw()
    cam:detach()
end
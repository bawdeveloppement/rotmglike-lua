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

local screens = {
    { name = "main_menu", buildIndex = 1 },
    { name = "option", buildIndex = 2 },
    { name = "play", buildIndex = 3 },
}

_G.xle = require(_G.engineDir .. "xle")

_G.xle.Init:new(screens)
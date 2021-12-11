_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.libDir    = _G.baseDir .. "lib."
_G.engineDir    = _G.libDir .. "engine."
_G.srcDir    = _G.baseDir .. "src."
_G.callbacks = {
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
        "resize",
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
    }
}

love.graphics.setDefaultFilter("nearest")

local screens = {
    { name = "main_menu", buildIndex = 1 },
    { name = "option", buildIndex = 2 },
    { name = "play", buildIndex = 3 },
}

_G.xle = require(_G.engineDir .. "xle")
_G.xleInstance = _G.xle.Init:new(screens)
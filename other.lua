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

local God = require(_G.engineDir .. "god"):new()
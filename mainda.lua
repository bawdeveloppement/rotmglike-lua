_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.engineDir      = _G.baseDir .. "engine."

local Class = require("middleclass")

local Entity = Class("Entity");

Entity.s

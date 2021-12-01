_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.engineDir    = _G.baseDir .. "engine."

local Entity    = require(_G.engineDir .. "entity")
local Transform = require("engine.components.transform")
local Sprite = require("engine.components.sprite")

-- Custom components
local Move = require("components.move")
local Character = require("components.character")

local world = {
    entities = {
        require("entities.bag"),
        require("entities.player")
    }
}

function love.load ( config )
end

function love.update (dt)
    for i, v in ipairs(world.entities) do
        v:update()
    end
end

function love.draw ()
    for i, v in ipairs(world.entities) do
        v:draw()
    end
end
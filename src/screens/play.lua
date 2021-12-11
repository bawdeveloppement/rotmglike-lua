local GamePlayScreen = require(_G.libDir .. "middleclass")("GamePlayScreen", _G.xle.Screen)

_G.cam = require("lib.camera")()

local Map = require(_G.engineDir .. "tiledmap")
local map = Map:new("nexus")

local player = require("src.entities.player"):new()
local camera = {
    x = 0,
    y = 0
}
function GamePlayScreen:initialize (name, active)
    _G.xle.Screen.initialize(self, name, active)
end

function GamePlayScreen:update()
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

function GamePlayScreen:draw()
    cam:attach()
        map:draw()
        player:draw()
    cam:detach()
end

return GamePlayScreen;
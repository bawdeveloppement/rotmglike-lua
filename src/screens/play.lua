local GamePlayScreen = require(_G.libDir .. "middleclass")("GamePlayScreen", _G.xle.Screen)

_G.cam = require("lib.camera")()

local Map = require(_G.engineDir .. "tiledmap")
local map = Map:new("nexus")

function GamePlayScreen:initialize (name, active)
    _G.xle.Screen.initialize(self, name, active)

    self.player = nil
end

function GamePlayScreen:init()
    _G.xle.Screen.init(self)
    
    self.player = require(_G.srcDir .. "entities.player"):new()
end

function GamePlayScreen:update(...)
    if self.player ~= nil then
        self.player:update(...)
        cam:lookAt(self.player:getComponent("TransformComponent").position.x, self.player:getComponent("TransformComponent").position.y)
    end
    
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
        if self.player ~= nil then
            self.player:draw()
        end
    cam:detach()
end

function GamePlayScreen:keyreleased(...)
    if self.player ~= nil then
        self.player:keyreleased(...)
    end
end

function GamePlayScreen:keypressed(...)
    if self.player ~= nil then
        self.player:keypressed(...)
    end
end

function GamePlayScreen:mousereleased(...)
    if self.player ~= nil then
        self.player:mousereleased(...)
    end
end

function GamePlayScreen:mousepressed(...)
    if self.player ~= nil then
        self.player:mousepressed(...)
    end
end
return GamePlayScreen;
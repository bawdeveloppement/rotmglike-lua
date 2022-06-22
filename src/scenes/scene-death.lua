local GameDeathScreen = require(_G.libDir .. "middleclass")("GameDeathScreen", _G.xle.Screen)

local ButtonElement = require(_G.engineDir .. "game_objects.interface_elements.main").ButtonElement


function GameDeathScreen:initialize (name, active)
    _G.xle.Scene.initialize(self, name, active)
end

function GameDeathScreen:init()
    _G.xle.Scene.init(self)

    love.window.setTitle(self.name)

    self.screenAudio = _G.xle.ResourcesManager:getOrAddSound("death_screen.mp3", "music")

    if self.screenAudio ~= nil then
        self.screenAudio:play()
    end

    self.nodes = {
        ButtonElement = ButtonElement:new("", 0, 0)
    }
end

function GameDeathScreen:draw(...)
    for k in pairs(self.nodes) do
        if self.nodes[k].draw ~= nil then
            self.nodes[k]:draw(...)
        end
    end
end

function GameDeathScreen:update(...)
    for k in pairs(self.nodes) do
        if self.nodes[k].update ~= nil then
            self.nodes[k]:update(...)
        end
    end
end

function GameDeathScreen:mousepressed (...)
    for k in pairs(self.nodes) do
        if self.nodes[k].mousepressed ~= nil then
            self.nodes[k]:mousepressed(...)
        end
    end
end

function GameDeathScreen:mousereleased (...)
    for k in pairs(self.nodes) do
        if self.nodes[k].mousereleased ~= nil then
            self.nodes[k]:mousereleased(...)
        end
    end
end

function GameDeathScreen:keypressed (...)
    local key = ...
    if key == "escape" then
        _G.xle.Screen.goToScreen("main_menu");
    end
    if key == "f" then
        love.window.setMode(1680, 1050, { fullscreen = true, fullscreentype = "desktop" })
    end
    for k in pairs(self.nodes) do
        if self.nodes[k].keypressed ~= nil then
            self.nodes[k]:keypressed(...)
        end
    end
end

function GameDeathScreen:keyreleased (...)
    -- local key = ...
    for k in pairs(self.nodes) do
        if self.nodes[k].keyreleased ~= nil then
            self.nodes[k]:keyreleased(...)
        end
    end
end

return GameDeathScreen;
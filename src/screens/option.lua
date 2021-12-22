local GameOptionScreen = require(_G.libDir .. "middleclass")("GameOptionScreen", _G.xle.Screen)
local VolumeControllerObject = require(_G.srcDir .. "go.volume_controller")

function GameOptionScreen:initialize (name, active)
    _G.xle.Screen.initialize(self, name, active)
end

function GameOptionScreen:init()
    _G.xle.Screen.init(self)
    love.window.setTitle(self.name)
    
    self.screenAudio = _G.xle.ResourcesManager:getOrAddSound("sorc.mp3", "music")

    if self.screenAudio ~= nil then
        self.screenAudio:play()
    end

    self.volumeController = VolumeControllerObject:new()
end

function GameOptionScreen:draw()
    if self.volumeController ~= nil then
        self.volumeController:draw()
    end
end

function GameOptionScreen:update()
    if self.volumeController ~= nil then
        self.volumeController:update()
    end
end

function GameOptionScreen:mousepressed (mx, my, button)
    if self.volumeController ~= nil then
        self.volumeController:mousepressed (mx, my, button)
    end
end

function GameOptionScreen:keypressed (key)
    if key == "f" then
        love.window.setFullscreen(true)
    end
    if key == "escape" then
        _G.xle.Screen.goToScreen("main_menu");
    end
end

return GameOptionScreen;
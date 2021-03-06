local GameOptionScreen = require(_G.libDir .. "middleclass")("GameOptionScreen", _G.xle.Scene)

local SelectElement = require(_G.engineDir .. "game_objects.interface_elements.main").SelectElement

local VolumeControllerObject = require(_G.srcDir .. "prefabs.prefab-volume_controller")
local DimensionControllerObject = require(_G.srcDir .. "prefabs.prefab-dimension_controller")

function GameOptionScreen:initialize (name, active)
    _G.xle.Scene.initialize(self, name, active)
end

function GameOptionScreen:init()
    _G.xle.Scene.init(self)

    love.window.setTitle(self.name)

    self.screenAudio = _G.xle.ResourcesManager:getOrAddSound("sorc.mp3", "music")

    if self.screenAudio ~= nil then
        self.screenAudio:play()
    end

    self.nodes = {
        volumeController = VolumeControllerObject:new(20, 25),
        dimensionController = DimensionControllerObject:new(10, 100),
        screenTypeController = SelectElement:new(
            { x = 10, y = 150},
            {
                { id="fullscreen", text="Fullscreen", value="exclusive"},
                { id="windowedfullscreen", text="Windowed fullscreen", value="desktop" },
                { id="windowed", text="Windowed", value="window" }
            }
        )
    }

    self.nodes.volumeController:addOnChangeEvent("mastervolume", function ( volume )
        love.audio.setVolume(volume);
    end)

    self.nodes.dimensionController:addOnChangeEvent("changedimension", function ( newDimension )
        love.window.setMode(newDimension.value.width, newDimension.value.height, newDimension.value.flags)
    end)

    self.nodes.screenTypeController:addOnChangeEvent("changedimension", function ( newDimension )
        local w, h = love.window.getMode()
        if newDimension.value ~= "window" then
            love.window.setMode(w, h, { fullscreen = true,  fullscreentype = newDimension.value })
        else
            love.window.setMode(w, h, { fullscreen = false })
        end
    end)
end

function GameOptionScreen:draw(...)
    for k in pairs(self.nodes) do
        if self.nodes[k].draw ~= nil then
            self.nodes[k]:draw(...)
        end
    end
end

function GameOptionScreen:update(...)
    for k in pairs(self.nodes) do
        if self.nodes[k].update ~= nil then
            self.nodes[k]:update(...)
        end
    end
end

function GameOptionScreen:mousepressed (...)
    for k in pairs(self.nodes) do
        if self.nodes[k].mousepressed ~= nil then
            self.nodes[k]:mousepressed(...)
        end
    end
end

function GameOptionScreen:mousereleased (...)
    for k in pairs(self.nodes) do
        if self.nodes[k].mousereleased ~= nil then
            self.nodes[k]:mousereleased(...)
        end
    end
end

function GameOptionScreen:keypressed (...)
    local key = ...
    if key == "escape" then
        _G.xle.Screen.goToScreen("main_menu_screen");
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

function GameOptionScreen:keyreleased (...)
    -- local key = ...
    for k in pairs(self.nodes) do
        if self.nodes[k].keyreleased ~= nil then
            self.nodes[k]:keyreleased(...)
        end
    end
end

return GameOptionScreen;
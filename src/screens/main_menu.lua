local GameMainMenuScreen = require(_G.libDir .. "middleclass")("GameMainMenuScreen", _G.xle.Screen)
local Button = require(_G.engineDir .. "game_objects.main").InterfaceElements.Button

function GameMainMenuScreen:initialize (name, active )
    _G.xle.Screen.initialize(self, name, active)
end

function GameMainMenuScreen:init()
    _G.xle.Screen.init(self)
    love.window.setTitle(self.name)

    self.nodes = {
        playButton = Button:new("play", 10, 10),
        optionButton = Button:new("option", 10, 50)
    }

    self.nodes.playButton:addOnClickEvent("changeScreen", function ()
        _G.xle.Screen.goToScreen("play");
    end)

    self.nodes.optionButton:addOnClickEvent("changeScreen", function ()
        _G.xle.Screen.goToScreen("option");
    end)
end

function GameMainMenuScreen:update(...)
    for k in pairs(self.nodes) do
        if self.nodes[k].update ~= nil then
            self.nodes[k]:update(...)
        end
    end
end

function GameMainMenuScreen:draw(...)
    for k in pairs(self.nodes) do
        if self.nodes[k].draw ~= nil then
            self.nodes[k]:draw(...)
        end
    end
end

function GameMainMenuScreen:mousereleased(...)
    local mx, my, button = ...
    for k in pairs(self.nodes) do
        if self.nodes[k].mousereleased ~= nil then
            self.nodes[k]:mousereleased(...)
        end
    end
end

function GameMainMenuScreen:mousepressed(...)
    local mx, my, button = ...
    for i in ipairs(self.nodes) do
        if self.nodes[i].mousepressed ~= nil then
            self.nodes[i]:mousepressed(...)
        end
    end
    if button == 1 then
        if mx > 0 and mx < 100 and my > 0 and my < 32 then
            _G.xle.Screen.goToScreen("play")
        end

        if mx > 0 and mx < 100 and my > 48 and my < 72 then
            _G.xle.Screen.goToScreen("option");
        end
    end
end

return GameMainMenuScreen;
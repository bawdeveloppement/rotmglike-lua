local GameMainMenuScreen = require(_G.libDir .. "middleclass")("GameMainMenuScreen", _G.xle.Scene)
local ButtonElement = require(_G.engineDir .. "game_objects.main").InterfaceElements.ButtonElement

function GameMainMenuScreen:initialize (name, active )
    _G.xle.Scene.initialize(self, name, active)
end

function GameMainMenuScreen:init()
    _G.xle.Scene.init(self)
    love.window.setTitle(self.name)

    self.nodes = {
        playSoloButton = ButtonElement:new("Single Player", 10, 10),
        playMultiButton = ButtonElement:new("Online", 10, 50, true),
        optionButton = ButtonElement:new("option", 10, 100)
    }

    self.nodes.playSoloButton:addOnClickEvent("changeScreen", function ()
        _G.xle.Scene.goToScene("scene-play");
    end)

    self.nodes.optionButton:addOnClickEvent("changeScreen", function ()
        _G.xle.Scene.goToScene("scene-option");
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

function GameMainMenuScreen:mousepressed(...)
    for k in pairs(self.nodes) do
        if self.nodes[k].mousepressed ~= nil then
            self.nodes[k]:mousepressed(...)
        end
    end
end
function GameMainMenuScreen:mousereleased(...)
    for k in pairs(self.nodes) do
        if self.nodes[k].mousereleased ~= nil then
            self.nodes[k]:mousereleased(...)
        end
    end
end

return GameMainMenuScreen;
local GamePlayScreen = require(_G.libDir .. "middleclass")("GamePlayScreen", _G.xle.Screen)

function GamePlayScreen:initialize (name, active)
    _G.xle.Screen.initialize(self, name, active)
end

function GamePlayScreen:init()
    _G.xle.Screen.init(self)

    local World = require(_G.engineDir .. "world")
    local nexus = World:new("nexus", 4)
    
    self.nodes = {
        nexus,
    }
end

function GamePlayScreen:update(...)
    for i, v in ipairs(self.nodes) do
        if v.update ~= nil then
            v:update(...)
        end
    end
end

function GamePlayScreen:draw(...)
    for i, v in ipairs(self.nodes) do
        if v.draw ~= nil then
            v:draw(...)
        end
    end
end

function GamePlayScreen:keyreleased(...)
    for i, v in ipairs(self.nodes) do
        if v.keyreleased ~= nil then
            v:keyreleased(...)
        end
    end
end

function GamePlayScreen:keypressed(...)
    for i, v in ipairs(self.nodes) do
        if v.keypressed ~= nil then
            v:keypressed(...)
        end
    end
end

function GamePlayScreen:mousereleased(...)
    for i, v in ipairs(self.nodes) do
        if v.mousereleased ~= nil then
            v:mousereleased(...)
        end
    end
end

function GamePlayScreen:mousepressed(...)
    for i, v in ipairs(self.nodes) do
        if v.mousepressed ~= nil then
            v:mousepressed(...)
        end
    end
end

return GamePlayScreen;
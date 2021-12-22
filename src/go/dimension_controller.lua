local DimensionController = require(_G.libDir .. "middleclass")("DimensionController")
local SelectElement = require(_G.engineDir .. "game_objects.main").InterfaceElements.SelectElement

function DimensionController:initialize(x, y)

    self.select = SelectElement:new(
        { x = x, y = y, width = 200, height = 32 },
        _G.xle.Init.optionsCached
    )
end

function DimensionController:update(...)
    self.select:update(...)
end

function DimensionController:draw(...)
    self.select:draw(...)
end

function DimensionController:mousepressed(...)
    self.select:mousepressed(...)
end

function DimensionController:addOnChangeEvent(...)
    self.select:addOnChangeEvent(...)
end

function DimensionController:mousereleased(...)
    self.select:mousereleased(...)
end

return DimensionController
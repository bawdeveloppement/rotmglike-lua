local DimensionController = require(_G.libDir .. "middleclass")("DimensionController")
local SelectElement = require(_G.engineDir .. "game_objects.main").InterfaceElements.SelectElement

function DimensionController:initialize(x, y)
    local w, h = love.window.getMode()
    local alreadyI = "default"
    for i, v in ipairs(_G.xle.Init.optionsCached) do
        if v.value.width == w and v.value.height == h then
            alreadyI = v.id
        end
    end
    self.select = SelectElement:new(
        { x = x, y = y, width = 200, height = 32 },
        _G.xle.Init.optionsCached,
        alreadyI
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

        
local GOButtonStatsInterface = require(_G.libDir .. "middleclass")("GOButtonStatsInterface");

GOButtonStatsInterface.static.name = "GOManaBar"

function GOButtonStatsInterface:initialize()
    self.manaText = love.graphics.newText(_G.font, "")
end

function GOButtonStatsInterface:draw( show )
    local w, h = love.window:getMode()
    if show then
        love.graphics.setColor(128 / 255, 0, 128 / 255, 255);
        love.graphics.rectangle("fill", 10, h - 32 - 10, 32, 32)
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.print("C", 16, h - 32)
        love.graphics.rectangle("line", 10, h - 32 - 10, 32, 32)
    else
        love.graphics.setColor(0, 0, 0, 0.4);
        love.graphics.rectangle("fill", 10, h - 32 - 10, 32, 32)
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.print("C", 16, h-32)
        love.graphics.rectangle("line", 10, h - 32 - 10, 32, 32)
    end
end


function GOButtonStatsInterface:keyreleased (key)
    if key == "lshift" then lshift = true end
end


return GOButtonStatsInterface
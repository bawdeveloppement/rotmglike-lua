
        
local GOButtonInventory = require(_G.libDir .. "middleclass")("GOButtonInventory");

GOButtonInventory.static.name = "GOManaBar"

function GOButtonInventory:initialize()
end

function GOButtonInventory:draw( show )
    local w, h = love.window:getMode()
    if show then
        love.graphics.setColor(128/255, 0, 128/255, 255);
        love.graphics.rectangle("fill", 20 + 32, h - 32 - 10, 32, 32)
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.print("B", 65, h-32)
        love.graphics.rectangle("line", 20 + 32, h - 32 - 10, 32, 32)
    else
        love.graphics.setColor(0, 0, 0, 0.4);
        love.graphics.rectangle("fill", 20 + 32, h - 32 - 10, 32, 32)
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.print("B", 65, h-32)
        love.graphics.rectangle("line", 20 + 32, h - 32 - 10, 32, 32)
    end
end


function GOButtonInventory:keyreleased (key)
end


return GOButtonInventory
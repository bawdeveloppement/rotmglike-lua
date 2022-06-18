local GOManaBar = require(_G.libDir .. "middleclass")("GOManaBar");

GOManaBar.static.name = "GOManaBar"

function GOManaBar:initialize()
    self.manaText = love.graphics.newText(_G.font, "")
end

function GOManaBar:draw( stats )
    local w, h = love.window:getMode()
    self.manaText:set(""..stats.mana .. "\n / \n" .. stats.max_mana.base + stats.max_mana.equipment )
    love.graphics.setColor(0,255,200,255);
    love.graphics.rectangle("fill", w / 2 + 164, h - 74, 64, 64)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", w / 2 + 164, h - 74, 64, 64 * ( stats.mana / 100 ))
    love.graphics.draw(self.manaText,  w / 2 + 164 + 16 + 32 - self.manaText:getWidth(),h - 74 + (self.manaText:getHeight() / 2))
end


return GOManaBar
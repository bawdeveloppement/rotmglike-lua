local GOHealthBar = require(_G.libDir .. "middleclass")("GOHealthBar");

GOHealthBar.static.name = "GOHealthBar"

function GOHealthBar:initialize()
    self.healthText = love.graphics.newText(_G.font, "")
end

function GOHealthBar:draw( characterComponent )
    local w, h = love.window:getMode()
    self.healthText:set("".. math.floor(characterComponent.stats.life * 10) / 10 .. " / " .. characterComponent.stats.max_life)
    love.graphics.setColor(255, 0, 0, 255);
    love.graphics.rectangle("fill", w / 2 - 150, h - 68, 300 * ( characterComponent.stats.life / characterComponent.stats.max_life ), 32)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", w / 2 - 150, h - 68, 300, 32)
    love.graphics.draw(self.healthText,  w / 2 - self.healthText:getWidth() / 2, h - 68 + (self.healthText:getHeight() / 2))
end


return GOHealthBar
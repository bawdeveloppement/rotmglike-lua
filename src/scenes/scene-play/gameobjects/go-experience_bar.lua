local GOExperienceBar = require(_G.libDir .. "middleclass")("GOExperienceBar");

GOExperienceBar.static.name = "GOManaBar"

function GOExperienceBar:initialize()
    self.expText = love.graphics.newText(_G.font, "")
end

function GOExperienceBar:draw( characterComponent )
    local w, h = love.window:getMode()
    self.expText:set(""..characterComponent.exp .. " / " .. characterComponent.max_exp)
    love.graphics.setColor(0, 0, 0, 0.4);
    love.graphics.rectangle("fill", w / 2 - 150, h - 26, 300, 16)
    love.graphics.setColor(128/255, 0, 128/255, 1);
    love.graphics.rectangle("fill", w / 2 - 150, h - 26, 300 * ( characterComponent.exp / characterComponent.max_exp ), 16)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", w / 2 - 150, h - 26, 300, 16)
    love.graphics.draw(self.expText,  w / 2 - self.expText:getWidth() / 2, h - 24)
end


return GOExperienceBar
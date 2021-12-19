local GameMainMenuScreen = require(_G.libDir .. "middleclass")("GameMainMenuScreen", _G.xle.Screen)

function GameMainMenuScreen:initialize (name, active )
    _G.xle.Screen.initialize(self, name, active)

end

function GameMainMenuScreen:init()
    _G.xle.Screen.init(self)
    love.window.setTitle(self.name)
end

local mousex, mousey = 0, 0;
function GameMainMenuScreen:update()
    mousex, mousey = love.mouse.getPosition()
end

function GameMainMenuScreen:draw()
    if mousex > 0 and mousex < 100 and mousey > 0 and mousey < 32 then
        love.graphics.rectangle("fill", 0, 0, 100, 32)
        love.graphics.setColor(0,0,0,1)
        love.graphics.print("Play", 0, 0)
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Play", 0, 0)
    love.graphics.rectangle("line", 0, 0, 100, 32)

    if mousex > 0 and mousex < 100 and mousey > 48 and mousey < 72 then
        love.graphics.rectangle("fill", 0, 48, 100, 32)
        love.graphics.setColor(0,0,0,1)
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Option", 0, 48)
    love.graphics.rectangle("line", 0, 48, 100, 32)
end

function GameMainMenuScreen:mousepressed(mx, my, button)
    if button == 1 then
        if mx > 0 and mx < 100 and my > 0 and my < 32 then
            _G.xle.Screen.goToScreen("play");
        end

        if mx > 0 and mx < 100 and my > 48 and my < 72 then
            _G.xle.Screen.goToScreen("option");
        end
    end
end

return GameMainMenuScreen;
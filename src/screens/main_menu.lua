local GameMainMenuScreen = require(_G.libDir .. "middleclass")("GameMainMenuScreen", _G.xle.Screen)

function GameMainMenuScreen:initialize (name, active )
    _G.xle.Screen.initialize(self, name, active)

    love.window.setTitle(name)
end

local mousex, mousey = 0, 0;
function GameMainMenuScreen:update()
    mousex, mousey = love.mouse.getPosition()
end

function GameMainMenuScreen:draw()
    if mousex > 0 and mousex < 100 and mousey > 0 and mousey < 32 then
        love.graphics.rectangle("fill", 0, 0, 100, 32)
    end
    love.graphics.rectangle("line", 0, 0, 100, 32)
end

function GameMainMenuScreen:mousepressed(key)
end

return GameMainMenuScreen;
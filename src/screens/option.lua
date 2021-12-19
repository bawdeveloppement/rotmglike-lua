local GameOptionScreen = require(_G.libDir .. "middleclass")("GameOptionScreen", _G.xle.Screen)

function GameOptionScreen:initialize (name, active)
    _G.xle.Screen.initialize(self, name, active)
end


function GameOptionScreen:init()
    _G.xle.Screen.init(self)
    love.window.setTitle(self.name)
end

local soundObj = {
    rect = {
        x = 50,
        y = 50
    }
}

local currentVolume = 0
function GameOptionScreen:draw()
    local mx, my = love.mouse.getPosition()
    for i = 0, 9, 1 do
        if mx > soundObj.rect.x + i * 6 and mx < soundObj.rect.x + (i * 6) + 4 and my > soundObj.rect.y + 0 and my < soundObj.rect.y + 16 then
            love.graphics.rectangle("fill", soundObj.rect.x + i * 6, soundObj.rect.y + 10 - (i + 1), 4, 6 + i + 1)
            love.graphics.rectangle("line", soundObj.rect.x + i * 6, soundObj.rect.y + 10 - (i + 1), 4, 6 + i + 1)
        else
            if i <= currentVolume then
                love.graphics.rectangle("fill", soundObj.rect.x + i * 6, soundObj.rect.y + 10 - (i + 1), 4, 6 + i + 1)
            else
                love.graphics.rectangle("line", soundObj.rect.x + i * 6, soundObj.rect.y + 10 - (i + 1), 4, 6 + i + 1)
            end
        end
    end
    love.graphics.rectangle("line", soundObj.rect.x - 2, soundObj.rect.y - 2, 64, 20)
end

function GameOptionScreen:mousepressed (mx, my, button)
    if button == 1 then
    for i = 0, 9, 1 do
            if mx > soundObj.rect.x + i * 6 and mx < soundObj.rect.x + (i * 6) + 4 
            and my > soundObj.rect.y + 0 and my < soundObj.rect.y + 16 then
                currentVolume = i
            end
        end
    end
end

return GameOptionScreen;
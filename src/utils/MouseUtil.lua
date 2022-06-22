local MouseUtil = require(_G.libDir .. "middleclass")("MouseUtil")

MouseUtil.static.drawItem = function ()
    if _G.itemInMouse then
        local mx, my = love.mouse.getPosition()
        if _G.itemInMouse.item ~= nil then
            if _G.itemInMouse.item.Texture ~= nil then
                local image = _G.xle.ResourcesManager:getTexture(_G.itemInMouse.item.Texture.File);
                if image ~= nil then
                    local imageW, imageH = image:getDimensions()
                    local quad = love.graphics.newQuad(
                        8 * (_G.itemInMouse.item.Texture.Index % (imageW / 8)),
                        math.floor(_G.itemInMouse.item.Texture.Index / (imageW / 8)) * 8,
                        8,
                        8,
                        imageW, imageH
                    )
                    love.graphics.draw(image, quad, mx,  my, 0, 4);
                end
            elseif _G.itemInMouse.item.AnimatedTexture ~= nil then
                local image = _G.xle.ResourcesManager:getTexture(_G.itemInMouse.item.AnimatedTexture.File);
                if image ~= nil then
                    local imageW, imageH = image:getDimensions()
                    local quad = love.graphics.newQuad(
                        8 * (_G.itemInMouse.item.AnimatedTexture.Index % (imageW / 8)),
                        math.floor(_G.itemInMouse.item.AnimatedTexture.Index / (imageW / 8)) * 8,
                        8,
                        8,
                        imageW, imageH
                    )
                    love.graphics.draw(image, quad, mx,  my, 0, 4);
                end
            else
                love.graphics.rectangle("fill", mx, my, 32, 32)
            end
            love.graphics.print("".._G.itemInMouse.quantity, mx + 42, my)
        end
        
    end
end

return MouseUtil
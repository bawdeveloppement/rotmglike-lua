local Slot = require(_G.libDir .. "middleclass")
local CharacterComponent = require(_G.srcDir .. "components.character")

Slot.static.cacheText = {}

function Slot:initialize(rect)
    self.rect = {
        x = rect.x or 0,
        y = rect.y or 0,
        width = rect.width or 32,
        height = rect.height or 32
    }
    self.item = nil
    self.quantity = nil

    self.cacheText = {}
end

function Slot:getItem()
    return self.item
end

function Slot:removeItem()
    self.item = nil
    self.quantity = nil
end

function Slot:pickItem( quantity )
    if self.item ~= nil then
        if self.quantity <= quantity then
            local item = {
                item = self.item,
                quantity = self.quantity
            }
            -- print(quantity - self.quantity)
            self:removeItem();
            return item
        else
            self.quantity = self.quantity - quantity
            return {
                item = self.item,
                quantity = self.quantity
            }
        end
    else
        return nil
    end
end

function Slot:getQuantity()
    return self.quantity
end

function Slot:draw( ... )
    local mx, my = love.mouse.getPosition()
    if self.item ~= nil then
        if self.item.Texture ~= nil then
            local image = _G.xle.ResourcesManager:getTexture(self.item.Texture.File);
            if image ~= nil then
                local imageW, imageH = image:getDimensions()
                local quad = love.graphics.newQuad(
                    8 * (tonumber(self.item.Texture.Index, 16) % (imageW / 8)),
                    math.floor(tonumber(self.item.Texture.Index, 16) / (imageW / 8)) * 8,
                    8,
                    8,
                    imageW, imageH
                )
                love.graphics.draw(image, quad, self.rect.x, self.rect.y, 0, 4);
            else
                love.graphics.rectangle("fill", self.rect.x, self.rect.y, self.rect.width, self.rect.height)
            end
        else
            love.graphics.rectangle("fill", self.rect.x, self.rect.y, self.rect.width, self.rect.height)
        end
        if mx > self.rect.x and mx < self.rect.x + self.rect.width and my > self.rect.y and my < self.rect.y + self.rect.height then
            love.graphics.setColor(0,0,0,0.4)
            love.graphics.rectangle("fill", mx, my - 200, 300, 200)
            love.graphics.setColor(1,1,1,1)
            love.graphics.rectangle("line", mx, my - 200, 300, 200)
            local itemId = self.item.id or (""..#self.slots..love.math.random(0, 100))
            if self.cacheText[itemId] ~= nil then
                for i, v in ipairs(self.cacheText[itemId]) do
                    love.graphics.draw(v, mx + 10, my - 200 + i * v:getHeight())
                end
            else
                self.cacheText[itemId] = {}
                self.cacheText[itemId][1] = love.graphics.newText(_G.font1, itemId)
                local i = 2
                for k, v in pairs(self.item) do
                    if k ~= "$" and k ~= "blackBag" and k ~= "type" and k ~= "DisplayId" and k ~= "Sound"
                    and k ~= "Item" and k ~= "Usable" and k ~= "NumProjectiles" and k ~= "BagType" and k ~= "Class" then
                        -- if type(v) ~= "table" or k == "ActivateOnEquip" then
                        --     if k == "ActivateOnEquip" then
                        --         self.cacheText[itemId][i] = love.graphics.newText(_G.font1, {{128/255, 128/255, 128/255, 1}, "Stats : \n"})
                        --         for kact, vact in pairs(self.item[k]) do
                        --             if kact == "IncrementStat" then
                        --                 if CharacterComponent.statOffToHere[vact.stat] ~= nil then
                        --                     i = i + 1
                        --                     self.cacheText[itemId][i] = love.graphics.newText(_G.font, {{128/255, 128/255, 128/255, 1}, "Stats : \n",  {1,1,1,1}, CharacterComponent.statOffToHere[vact.stat] ..  " : " ..  vact.amount })
                        --                 end
                        --             end
                        --         end
                        --     else
                        --         self.cacheText[itemId][i] = love.graphics.newText(_G.font1, k .. " : " .. tostring(v))
                        --     end
                        --     i = i + 1
                        -- end
                    end
                end
            end
        end
    end
end

return Slot
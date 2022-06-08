local Container = require(_G.libDir .. "middleclass")("Container")
local CharacterComponent = require(_G.srcDir .. "components.component-character")

function Container:initialize(length, x, y, parent)
    self.rect = {
        x = x or 0,
        y = y or 0,
        width = 220,
        height = 220
    }

    self.parent = parent or nil
    self.length = length
    self.slots = {}

    for i = 1, self.length, 1 do
        table.insert(self.slots, #self.slots + 1, { item = nil, quantity = 0 })
    end

    self.cacheText = {}
end

function Container:addItemInFirstEmptySlot (item, quantity )
    local index = 0
    for i, v in ipairs(self.slots) do
        if self.slots[i].item == nil then
            index = i
            break
        end
    end
    if index == 0 then
        return
    else
        self.slots[index] = {
            item = item,
            quantity = quantity or 1
        }
    end
end

function Container:removeFirstItem ( item, quantity )
    table.remove(self.slots, 1)
end

function Container:setItemInSlotId ( slotId, item, quantity)
    if self.slots[slotId].item ~= nil then
        if self.slots[slotId].item == item.name then
            self.slots[slotId].quantity = self.slots[slotId].quantity + (quantity or 1)
            return nil
        else
            local toSave = nil
            toSave = self.slots[slotId];
            self.slots[slotId] = {
                item = item,
                quantity = quantity
            }
            return toSave
        end
    else
        self.slots[slotId] = {
            item = item,
            quantity = quantity or 1
        }
        return nil
    end
end

function Container:getSlotById(id)
    return self.slots[id]
end

function Container:extend( slotNumbers )
    self.length = self.length + (slotNumbers or 0)
end

--#region Draw
function Container:drawItem(x, y, index)
    local mx, my = love.mouse.getPosition()
    if self.slots[index].item ~= nil then
        local item = self.slots[index].item;
        if item.Texture ~= nil then
            local image = _G.xle.ResourcesManager:getTexture(item.Texture.File);
            if image ~= nil then
                local imageW, imageH = image:getDimensions()
                local quad = love.graphics.newQuad(
                    8 * (item.Texture.Index % (imageW / 8)),
                    math.floor(item.Texture.Index / (imageW / 8)) * 8,
                    8,
                    8,
                    imageW, imageH
                )
                love.graphics.draw(image, quad, x, y, 0, 4);
            else
                love.graphics.rectangle("fill", x, y, 32, 32)
            end
        elseif item.AnimatedTexture ~= nil then
            if item.AnimatedTexture.File == "playersSkins" then
                print(item.id)
            end
            local image = _G.xle.ResourcesManager:getTexture(item.AnimatedTexture.File);
            if image ~= nil then
                local imageW, imageH = image:getDimensions()
                local quad = love.graphics.newQuad(
                    8 * (item.AnimatedTexture.Index % (imageW / 8)),
                    math.floor(item.AnimatedTexture.Index / (imageW / 8)) * 8,
                    8,
                    8,
                    imageW, imageH
                )
                love.graphics.draw(image, quad, x, y, 0, 4);
            else
                love.graphics.rectangle("fill", x, y, 32, 32)
            end
        else
            love.graphics.rectangle("fill", x, y, 32, 32)
        end
        
        if mx > x and mx < x + 32 and my > y and my < y + 32 then
            love.graphics.setColor(0,0,0,0.4)
            love.graphics.rectangle("fill", mx, my - 200, 300, 200)
            love.graphics.setColor(1,1,1,1)
            love.graphics.rectangle("line", mx, my - 200, 300, 200)
            local itemId = self.slots[index].item.id or (""..#self.slots..love.math.random(0, 100))
            print(self.slots[index].item.id)
            if self.cacheText[itemId] ~= nil then
                love.graphics.draw(self.cacheText[itemId], mx + 10, my - 200)
            else
                self.cacheText[itemId] = love.graphics.newText(_G.font1, itemId)
                local lastIndex = 1
                local newHeight = 0
                for k, v in pairs(self.slots[index].item) do
                    if k ~= "$" and k ~= "id" and k ~= "Texture" and k ~= "Projectile" and k ~= "OldSound" and k ~= "blackBag" and k ~= "type" and k ~= "DisplayId" and k ~= "Sound"
                        and k ~= "Item" and k ~= "Potion" and k ~= "Activate" and k ~= "Usable" and k ~=  "ExtraTooltipData" and k ~= "Description" and k ~= "NumProjectiles" and k ~= "BagType" and k ~= "Class" then
                        -- Handle Activate:key
                        if k == "Consumable" then
                            newHeight = newHeight + self.cacheText[itemId]:getHeight(lastIndex)
                            lastIndex = self.cacheText[itemId]:addf(k, 300, "left", 0, newHeight + self.cacheText[itemId]:getHeight(lastIndex))
                        elseif k == "ActivateOnEquip" then
                            -- newHeight = newHeight + self.cacheText[itemId]:getHeight(lastIndex)
                            -- lastIndex = self.cacheText[itemId]:addf({{128/255, 128/255, 128/255, 1}, "Stats : \n"}, 200, "left",0, newHeight)
                            -- for kact, vact in pairs(self.slots[index].item[k]) do
                            --     if kact == "IncrementStat" then
                            --         if CharacterComponent.statOffToHere[vact.stat] ~= nil then
                            --             newHeight = newHeight + self.cacheText[itemId]:getHeight(lastIndex)
                            --             lastIndex = self.cacheText[itemId]:addf({{128/255, 128/255, 128/255, 1}, "Stats : \n",  {1,1,1,1}, CharacterComponent.statOffToHere[vact.stat] ..  " : " ..  vact.amount }, 200, "left", 0, newHeight)
                            --         end
                            --     end
                            -- end
                        else
                            newHeight = newHeight + self.cacheText[itemId]:getHeight(lastIndex)
                            lastIndex = self.cacheText[itemId]:addf(k .. " : " .. tostring(v), 300, "left", 0, newHeight + self.cacheText[itemId]:getHeight(lastIndex))
                            print(k ..newHeight .. "index" .. lastIndex)
                        end
                    end
                end
            end
        end
        
    end
end

function Container:drawSlot(x, y, i)
    love.graphics.rectangle("line", x, y, 32, 32)
    if self.slots[i].item ~= nil then
        self:drawItem(x, y, i)
    end
end

function Container:getItemCount()
    local items = 0
    for i, v in ipairs(self.slots) do
        if self.slots[i].item ~= nil then
            items = items + 1
        end
    end
    return items
end


function Container:draw()
    local w, h = love.window.getMode()
    -- Container Interface
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", 10, h- 52 - self.rect.height, self.rect.width, self.rect.height);
    love.graphics.setColor(0, 0, 0, 0.4);
    love.graphics.rectangle("fill", 10, h- 52 - self.rect.height, self.rect.width, self.rect.height);
    love.graphics.setColor(1, 1, 1, 1);
    love.graphics.print("Container : "..self:getItemCount().." items.", 10, h-52-240)

    local i = 1
    for y = 1, self.length / 5, 1 do
        for x = 1, 5, 1 do
            self:drawSlot(20 + (10 + 32) * (x - 1), (h - 94 - 210 ) + 42 * y, i)
            i = i + 1
        end
    end
end
--#endregion

function Container:mousepressed( mx, my, button)
    local w, h = love.window.getMode()
    if button == 1 then
        local i = 1
        for y = 1, self.length / 5, 1 do
            for x = 1, 5, 1 do
                if mx > 20 + (10 + 32) * (x - 1) and mx < 20 + (32) + (10 + 32) * (x - 1) and my > (h - 94 - 210 ) + 42 * y and my < (h - 94 - 210 ) + 32 + 42 * y then
                    if self.parent.itemInMouse.item == nil and self.slots[i].item ~= nil then
                        self.parent.itemInMouse = {
                            item = self.slots[i].item,
                            quantity = self.slots[i].quantity,
                            lastIndex = {
                                origin = "bag",
                                value = i
                            }
                        }
                        self.slots[i] = {
                            item = nil,
                            quantity = 0
                        }
                    end
                end
                i = i + 1
            end
        end
    end
end

function Container:mousereleased( mx, my, button)
    local w, h = love.window.getMode()
    if button == 1 then
        local i = 1
        for y = 1, self.length / 5, 1 do
            for x = 1, 5, 1 do
                if mx > 20 + (10 + 32) * (x - 1) and mx < 20 + (32) + (10 + 32) * (x - 1) and my > (h - 94 - 210 ) + 42 * y and my < (h - 94 - 210 ) + 32 + 42 * y then
                    if self.parent.itemInMouse.item ~= nil then
                        if self.slots[i].item == nil then
                            self.slots[i] = {
                                item = self.parent.itemInMouse.item,
                                quantity = self.parent.itemInMouse.quantity
                            }
                            self.parent.itemInMouse = {
                                item = nil,
                                quantity = 0,
                                lastIndex = nil
                            }
                        else
                            local oldItem = self.slots[i]
                            self.slots[i] = {
                                item = self.parent.itemInMouse.item,
                                quantity = self.parent.itemInMouse.quantity
                            }
                            if self.parent.itemInMouse.lastIndex ~= nil then
                                if self.parent.itemInMouse.lastIndex.origin == "bag" then
                                    self.slots[self.parent.itemInMouse.lastIndex.value] = oldItem
                                else
                                    self.parent.quickSlots[self.parent.itemInMouse.lastIndex.value] = oldItem
                                end
                            end
                            self.parent.itemInMouse = {
                                item = nil,
                                quantity = 0,
                                lastIndex = 0
                            }
                        end
                    end
                end
                i = i + 1
            end
        end
    end
end

function Container:getRect()
    local w, h = love.window.getMode()
    return {
        x = 10,
        y = h- 52 - self.rect.height,
        width = self.rect.width,
        height = self.rect.height
    }
end

return Container
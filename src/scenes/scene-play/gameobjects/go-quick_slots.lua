local GOQuickSlots = require(_G.libDir .. "middleclass")("GOQuickSlots");

GOQuickSlots.static.name = "GOQuickSlots"

function GOQuickSlots:initialize()

    self.cacheText = {}
end

function GOQuickSlots:canPutInQuickSlot( slotId, item, quickSlots)
    if quickSlots[slotId] ~= nil then
        if type(quickSlots[slotId].slotTypes) == "table" then
            local slotTypeEqual = false
            for i, v in ipairs(quickSlots[slotId].slotTypes) do
                if tostring(v) == item.SlotType then
                    slotTypeEqual = true
                end
            end
            return slotTypeEqual
        else
            if quickSlots[slotId].slotTypes == 0 then
                return true
            else
                return false
            end
        end
    else
        return false
    end
end
function GOQuickSlots:draw( quickSlots )
    local mx, my = love.mouse.getPosition()
    local w, h = love.window.getMode()
    for i, v in ipairs(quickSlots) do
        local slotx = w / 2 - 150 + (i - 1) * 42
        local sloty = h - 110
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("line", slotx, sloty, 32, 32)
        love.graphics.setColor(0,0,0, 0.4)
        love.graphics.rectangle("fill", slotx, sloty, 32, 32)
        love.graphics.setColor(1,1,1,1)

        if quickSlots[i].item ~= nil then
            local item = quickSlots[i].item;
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
                    love.graphics.draw(image, quad, slotx,  sloty, 0, 4);
                else
                    love.graphics.rectangle("fill",slotx,  sloty, 32, 32)
                end
            elseif item.AnimatedTexture ~= nil then
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
                    love.graphics.draw(image, quad, slotx,  sloty, 0, 4);
                else
                    love.graphics.rectangle("fill",slotx,  sloty, 32, 32)
                end
            else
                love.graphics.rectangle("fill", slotx,  sloty, 32, 32)
            end
            love.graphics.print(""..quickSlots[i].quantity, slotx, sloty)
            
            if mx > slotx and mx < slotx + 32 and my > sloty and my < sloty + 32 then
                love.graphics.setColor(0,0,0,0.4)
                love.graphics.rectangle("fill", mx, my - 200, 300, 200)
                love.graphics.setColor(1,1,1,1)
                love.graphics.rectangle("line", mx, my - 200, 300, 200)
                local itemId = item.id or (""..#quickSlots..love.math.random(0, 100))
                if self.cacheText[itemId] ~= nil then
                    love.graphics.draw(self.cacheText[itemId], mx + 10, my - 200)
                else
                    self.cacheText[itemId] = love.graphics.newText(_G.font1, itemId)
                    local lastIndex = 1
                    local newHeight = 0
                    for k, v in pairs(item) do
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
        else
            love.graphics.setColor(0.1,0.1,0.1,1)
            if i == 4 then
                local item = _G.dbObject.createEquipementById("Broad Sword")
                if item ~= nil then
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
                        love.graphics.draw(image, quad, slotx,  sloty, 0, 4);
                    else
                        love.graphics.rectangle("fill",slotx,  sloty, 32, 32)
                    end
                end
            elseif i == 6 then
                local item = _G.dbObject.createEquipementById("Leather Armor")
                if item ~= nil then
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
                        love.graphics.draw(image, quad, slotx,  sloty, 0, 4);
                    else
                        love.graphics.rectangle("fill",slotx,  sloty, 32, 32)
                    end
                end
            elseif i == 7 then
                local item = _G.dbObject.createEquipementById("Ring of Magic")
                if item ~= nil then
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
                        love.graphics.draw(image, quad, slotx,  sloty, 0, 4);
                    else
                        love.graphics.rectangle("fill",slotx,  sloty, 32, 32)
                    end
                end
            end
            love.graphics.setColor(1,1,1,1)
        end
    end
end

function GOQuickSlots:mousepressed(mx, my, button, quickSlots)
    local w, h = love.window.getMode()
    

    if button == 1 then
        for i, v in ipairs(quickSlots) do
            if mx > w / 2 - 150 + (i - 1) * 42 and mx < w / 2 - 150 + (i - 1) * 42 + 32 and my > h - 110 and my < h - 110 + 32 then
                if _G.itemInMouse.item == nil and quickSlots[i].item ~= nil then
                    _G.itemInMouse.item = quickSlots[i].item
                    _G.itemInMouse.quantity = quickSlots[i].quantity
                    _G.itemInMouse.lastIndex = {
                        origin = "quickslot",
                        value = i
                    }
                    quickSlots[i].item = nil
                    quickSlots[i].quantity = 0
                end
            end
        end
    end
end

function GOQuickSlots:mousereleased(mx, my, button, quickSlots, inventory)
    local w, h = love.window.getMode()
    if button == 1 then
        for i, v in ipairs(quickSlots) do
            if mx > w / 2 - 150 + (i - 1) * 42 and mx < w / 2 - 150 + (i - 1) * 42 + 32 and my > h - 110 and my < h - 110 + 32 then
                if _G.itemInMouse.item ~= nil then
                    if quickSlots[i].item == nil then
                        print(self:canPutInQuickSlot(i, _G.itemInMouse.item, quickSlots))
                        if self:canPutInQuickSlot(i, _G.itemInMouse.item, quickSlots) then
                            quickSlots[i].item = _G.itemInMouse.item
                            quickSlots[i].quantity = _G.itemInMouse.quantity
                            _G.itemInMouse = {
                                item = nil,
                                quantity = 0,
                                lastIndex = nil
                            }
                        else
                            if _G.itemInMouse.lastIndex.origin == "bag" then
                                inventory:setItemInSlotId(_G.itemInMouse.lastIndex.value, _G.itemInMouse.item, _G.itemInMouse.quantity)
                               _G.itemInMouse = {
                                   item = nil,
                                   quantity = 0,
                                   lastIndex = nil
                               }
                            end
                        end
                    elseif quickSlots[i].item ~= nil then
                        local old = {
                            item = quickSlots[i].item,
                            quantity = quickSlots[i].quantity
                        }
                        quickSlots[i].item = _G.itemInMouse.item
                        quickSlots[i].quantity = _G.itemInMouse.quantity
                        if _G.itemInMouse.lastIndex ~= nil then
                            if _G.itemInMouse.lastIndex.origin == "quickslot" then
                                quickSlots[_G.itemInMouse.lastIndex.value] = old
                            else
                                inventory:setItemInSlotId(_G.itemInMouse.lastIndex.value, old.item, old.quantity)
                            end
                        end
                        _G.itemInMouse = {
                            item = nil,
                            quantity = 0,
                            lastIndex = nil
                        }
                    end
                end
            else
                -- if not self.mouseIsHoverContainer then
                --     if _G.itemInMouse.item ~= nil then
                --         if _G.itemInMouse.lastIndex.origin == "quickslot" then
                --             quickSlots[_G.itemInMouse.lastIndex.value] = {
                --                 item = _G.itemInMouse.item,
                --                 quantity = _G.itemInMouse.quantity
                --             }
                --             _G.itemInMouse.item = nil
                --             _G.itemInMouse.quantity = 0
                --             _G.itemInMouse.lastIndex = nil
                --             _G.errorAudio:play()
                --         elseif _G.itemInMouse.lastIndex.origin == "bag" then
                --             self.bag:setItemInSlotId(_G.itemInMouse.lastIndex.value, _G.itemInMouse.item, _G.itemInMouse.quantity)
                --             _G.itemInMouse.item = nil
                --             _G.itemInMouse.quantity = 0
                --             _G.itemInMouse.lastIndex = nil
                --             _G.errorAudio:play()
                --         end
                --     end
                -- end
            end
        end
    end
end


return GOQuickSlots
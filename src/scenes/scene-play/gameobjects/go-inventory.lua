local GOInventory = require(_G.libDir .. "middleclass")("GOInventory");
local CharacterComponent = require(_G.srcDir .. "components.component-character")
GOInventory.static.name = "GOInventory"

function GOInventory:initialize()
    self.rect = {
        x = 10,
        y = y or 0,
        width = 220,
        height = 220
    }

    self.cacheText = {}
end

function GOInventory:draw( inventory )
    local w, h = love.window.getMode()
    -- Container Interface
    
    self.rect.height = 10 + (inventory.length / 5 * 32) + inventory.length / 5 * 10
    self.rect.y = h - 52 - self.rect.height

    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", self.rect.x, self.rect.y, self.rect.width, self.rect.height);
    love.graphics.setColor(0, 0, 0, 0.4);
    love.graphics.rectangle("fill", self.rect.x, self.rect.y, self.rect.width, self.rect.height);
    love.graphics.setColor(1, 1, 1, 1);
    love.graphics.print("Container : "..inventory:getItemCount().." items.", 10, self.rect.y - 20)

    local i = 1
    for ypos = 1, inventory.length / 5, 1 do
        for x = 1, 5, 1 do
            self:drawSlot(
                20 + (10 + 32) * (x - 1),
                self.rect.y + 10 + (42 * (ypos - 1)),
                i,
                inventory
            )
            i = i + 1
        end
    end
end


function GOInventory:mousepressed( mx, my, button, inventory)
    local w, h = love.window.getMode()
    if button == 1 then
        local i = 1

        for y = 1, inventory.length / 5, 1 do
            for x = 1, 5, 1 do
                if mx > 20 + (10 + 32) * (x - 1) and mx < 20 + (32) + (10 + 32) * (x - 1) and my > self.rect.y + 10 + (42 * (y - 1)) and my < (self.rect.y + 10 ) + 32 + (42 * (y - 1)) then
                    if _G.itemInMouse.item == nil and inventory.slots[i].item ~= nil then
                        _G.itemInMouse = {
                            item = inventory.slots[i].item,
                            quantity = inventory.slots[i].quantity,
                            lastIndex = {
                                origin = "bag",
                                value = i
                            }
                        }
                        inventory.slots[i] = {
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

function GOInventory:drawItem(x, y, index, inventory)
    local mx, my = love.mouse.getPosition()
    if inventory.slots[index].item ~= nil then
        local item = inventory.slots[index].item;
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
            local itemId = inventory.slots[index].item.id or (""..#inventory.slots..love.math.random(0, 100))
            -- print(inventory.slots[index].item.id)
            local newText = love.graphics.newText(_G.font1, itemId)
            local lastIndex = 1
            local newHeight = 0
            for k, v in pairs(inventory.slots[index].item) do
                if k ~= "$" and k ~= "id" and k ~= "Texture" and k ~= "Projectile" and k ~= "OldSound" and k ~= "blackBag" and k ~= "type" and k ~= "DisplayId" and k ~= "Sound"
                    and k ~= "Item" and k ~= "Potion" and k ~= "AnimatedTexturecvb" and k ~= "Activate" and k ~= "Usable" and k ~=  "ExtraTooltipData" and k ~= "Description" and k ~= "NumProjectiles" and k ~= "BagType" and k ~= "Class" then
                    -- Handle Activate:key
                    if k == "Consumable" then
                        newHeight = newHeight + newText:getHeight(lastIndex)
                        lastIndex = newText:addf(k, 300, "left", 0, newHeight + newText:getHeight(lastIndex))
                    elseif k == "ActivateOnEquip" then
                        local vt = inventory.slots[index].item[k]["IncrementStat"]

                        newHeight = newHeight + newText:getHeight(lastIndex)
                        lastIndex = newText:addf({{0, 1, 0, 1}, "Stat: "}, 300, "left", 0, newHeight + newText:getHeight(lastIndex))
                        for ks, vs in pairs(vt) do
                            newHeight = newHeight + newText:getHeight(lastIndex)
                            lastIndex = newText:addf(" - " .. CharacterComponent.statOffToHere[ks] .. " : " .. vs, 300, "left", 0, newHeight + newText:getHeight(lastIndex))
                        end
                    
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
                        newHeight = newHeight + newText:getHeight(lastIndex)
                        lastIndex = newText:addf(k .. " : " .. tostring(v), 300, "left", 0, newHeight + newText:getHeight(lastIndex))
                    end
                end
            end
            love.graphics.draw(newText, mx + 10, my - 195)
            
        end
        
    end
end

function GOInventory:drawSlot(x, y, i, inventory)
    local mx, my = love.mouse.getPosition()

    if mx > x and mx < x + 32 and my > y and my < y + 32 then
        love.graphics.setColor(0,1,0,1)
    else
        love.graphics.setColor(1,1,1,1)
        
    end
    love.graphics.rectangle("line", x, y, 32, 32)
    if inventory.slots[i].item ~= nil then
        self:drawItem(x, y, i, inventory)
    end
end

function GOInventory:mousereleased( mx, my, button, inventory)
    local w, h = love.window.getMode()
    if button == 1 then
        local i = 1
        for y = 1, inventory.length / 5, 1 do
            for x = 1, 5, 1 do
                if mx > 20 + (10 + 32) * (x - 1) and mx < 20 + (32) + (10 + 32) * (x - 1) and my > self.rect.y + 10 + (42 * (y - 1)) and my < (self.rect.y + 10 ) + 32 + (42 * (y - 1)) then
                    if _G.itemInMouse.item ~= nil then
                        if inventory.slots[i].item == nil then
                            inventory.slots[i] = {
                                item = _G.itemInMouse.item,
                                quantity = _G.itemInMouse.quantity
                            }
                            _G.itemInMouse = {
                                item = nil,
                                quantity = 0,
                                lastIndex = nil
                            }
                        else
                            local oldItem = inventory.slots[i]
                            inventory.slots[i] = {
                                item = _G.itemInMouse.item,
                                quantity = _G.itemInMouse.quantity
                            }
                            if _G.itemInMouse.lastIndex ~= nil then
                                if _G.itemInMouse.lastIndex.origin == "bag" then
                                    inventory.slots[_G.itemInMouse.lastIndex.value] = oldItem
                                else
                                    self.parent.quickSlots[_G.itemInMouse.lastIndex.value] = oldItem
                                end
                            end
                            _G.itemInMouse = {
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
return GOInventory
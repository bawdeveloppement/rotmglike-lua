local Container = require(_G.libDir .. "middleclass")("Container")
local CharacterComponent = require(_G.srcDir .. "components.character")

function Container:initialize(length, x, y)
    
    self.position = {
        x = x or 0,
        y = y or 0
    }

    self.length = length
    self.slots = {}

    self.cacheText = {}
end

function Container:addItem ( item, quantity )
    if #self.slots < self.length then
        table.insert(self.slots, #self.slots + 1, {
            item = item,
            quantity = quantity or 1
        })
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
    if self.slots[index] ~= nil then
        local item = self.slots[index].item;
        if item.Texture ~= nil then
            local image = _G.xle.ResourcesManager:getTexture(item.Texture.File);
            if image ~= nil then
                local imageW, imageH = image:getDimensions()
                local quad = love.graphics.newQuad(
                    8 * (tonumber(item.Texture.Index, 16) % (imageW / 8)),
                    math.floor(tonumber(item.Texture.Index, 16) / (imageW / 8)) * 8,
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
        local mx, my = love.mouse.getPosition()
        if mx > x and mx < x + 32 and my > y and my < y + 32 then
            love.graphics.setColor(0,0,0,0.4)
            love.graphics.rectangle("fill", mx, my - 200, 300, 200)
            love.graphics.setColor(1,1,1,1)
            love.graphics.rectangle("line", mx, my - 200, 300, 200)
            if self.cacheText[self.slots[index].item["$"].id] ~= nil then
                for i, v in ipairs(self.cacheText[self.slots[index].item["$"].id]) do
                    love.graphics.draw(v, mx + 10, my - 200 + i * v:getHeight())
                end
            else
                self.cacheText[self.slots[index].item["$"].id] = {}
                self.cacheText[self.slots[index].item["$"].id][1] = love.graphics.newText(_G.font1, self.slots[index].item["$"].id)
                local i = 2
                for k, v in pairs(self.slots[index].item) do
                    if k ~= "$" then
                        if type(v) ~= "table" or k == "ActivateOnEquip" then
                            if k == "ActivateOnEquip" then
                                self.cacheText[self.slots[index].item["$"].id][i] = love.graphics.newText(_G.font1, {{128/255, 128/255, 128/255, 1}, "Stats : \n"})
                                if v["_"] == "IncrementStat" then
                                    if CharacterComponent.statOffToHere[v["$"].stat] ~= nil then
                                        self.cacheText[self.slots[index].item["$"].id][i]:setf({{128/255, 128/255, 128/255, 1}, "Stats : \n",  {1,1,1,1}, CharacterComponent.statOffToHere[v["$"].stat] ..  " : " ..  v["$"].amount }, 200, "left")
                                        i = i + 1
                                    end
                                end
                            else
                                self.cacheText[self.slots[index].item["$"].id][i] = love.graphics.newText(_G.font1, k .. " : " .. v)
                                print(self.cacheText[self.slots[index].item["$"].id][i]:getHeight())
                                i = i + 1
                            end
                            print(k)
                        end
                    end
                end
            end
        end
    end
end

function Container:drawSlot(x, y, i)
    love.graphics.rectangle("line", x, y, 32, 32)
    if self.slots[i] ~= nil then
        self:drawItem(x, y, i)
    end
end

function Container:getItemCount()
    local items = 0
    for i = 1, #self.slots, 1 do
        if self.slots[i] ~= nil then
            items = items + 1
        end
    end
    return items
end

function Container:draw()
    -- Container Interface
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", 10, 600- 52 - 220, 220, 220);
    love.graphics.setColor(0, 0, 0, 0.4);
    love.graphics.rectangle("fill", 10, 600- 52 - 220, 220, 220);
    love.graphics.setColor(1, 1, 1, 1);
    love.graphics.print("Container : "..self:getItemCount().." items.", 10, 600-52-240)

    local i = 1
    for y = 1, self.length / 5, 1 do
        for x = 1, 5, 1 do
            self:drawSlot(20 + (10 + 32) * (x - 1), (600 - 94 - 210 ) + 42 * y, i)
            i = i + 1
        end
    end
end
--#endregion

function Container:mousepressed( mousex, mousey, button)
    
end

function Container:mousereleased( mousex, mousey, button)
    
end

return Container
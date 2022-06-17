local Container = require(_G.libDir .. "middleclass")("Container")
local CharacterComponent = require(_G.srcDir .. "components.component-character")

function Container:initialize(length, x, y, parent)
    self.rect = {
        x = x or 0,
        y = y or 0,
        width = 220,
        height = 220
    }

    self.relative = true
    self.parent = parent or nil
    self.length = length

    self.slots = {}
    
    for i = 1, self.length, 1 do
        table.insert(self.slots, #self.slots + 1, { item = nil, quantity = 0 })
    end

    self.rect.height = 10 + (self.length / 5 * 32) + self.length / 5 * 10

    self.cacheText = {}

end

function Container:setPosition(x, y)
    self.rect.x = x
    self.rect.y = y
end

function Container:setItems(items)
    -- TODO: Assemble pair items

    -- Remove all items
    for i, v in ipairs(self.slots) do
        if self.slots[i].item ~= nil then
            self.slots[i] = {
                item = nil,
                quantity = 0
            }
        end
    end
    -- 
    local nextItemIndex = 1
    -- Check in table if item is already added
    for i, v in ipairs(items) do
        if self.slots[i].item == nil then
            self.slots[i] = {
                item = v,
                quantity = 1
            }
            nextItemIndex = nextItemIndex + 1 
        end
    end
    self.alreadySetItems = true
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

function Container:getItemCount()
    local items = 0
    for i, v in ipairs(self.slots) do
        if self.slots[i].item ~= nil then
            items = items + 1
        end
    end
    return items
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
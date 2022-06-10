local SelectElement = require(_G.libDir .. "middleclass")("SelectElement")

function SelectElement:initialize( rect, options, default )
    self.rect = {
        x = rect.x or 0,
        y = rect.y or 0,
        width = rect.width or 200,
        height = rect.height or 32
    }

    self.options = options


    self.optionSelected = default or 0


    self.onChange = {}

    self.show = false
    self.maxHeight = 200
    self.scrollbarGrabbed = false
    self.scrollbarPositionY = self.rect.y + self.rect.height + 12
end

function SelectElement:addOption( optionId, optionText, optionValue )
    table.insert(self.options, #self.options + 1, { id = optionId or "", text = optionText or "", value = optionValue })
end

function SelectElement:update()
    local mx, my = love.mouse:getPosition()
    local scrollBarHeight = self.maxHeight * (self.maxHeight / ((self.rect.height + 4) * #self.options + 4))

    if self.scrollbarGrabbed then
        self.scrollbarPositionY = my
    end

    if self.scrollbarPositionY + scrollBarHeight > self.rect.y + self.rect.height + 12 + self.maxHeight then
        self.scrollbarPositionY = (self.rect.y + self.rect.height + 12 + self.maxHeight) - scrollBarHeight
    end

    if self.scrollbarPositionY < self.rect.y + self.rect.height + 12 then
        self.scrollbarPositionY = self.rect.y + self.rect.height + 12
    end
end

function SelectElement:getOptionById( optionId )
    local option = nil
    if optionId == 0 then return option end
    if #self.options ~= 0 then
        for i, v in ipairs(self.options) do
            if v.id == optionId then
                option = v
            end
        end
    end
    return option
end

function SelectElement:draw(...)
    local mx, my = love.mouse.getPosition()
    if (mx > self.rect.x and mx < self.rect.x + self.rect.width and my > self.rect.y and my < self.rect.y + self.rect.height) or self.show then
        love.graphics.rectangle("fill", self.rect.x, self.rect.y + 4, self.rect.width, self.rect.height)
        love.graphics.rectangle("line", self.rect.x - 4, self.rect.y, self.rect.width + 8, self.rect.height + 8)
        love.graphics.rectangle("line", self.rect.x, self.rect.y + 4, self.rect.width, self.rect.height)
        
        love.graphics.setColor(0,0,0,1)
        if self:getOptionById(self.optionSelected) ~= nil then
            love.graphics.print(self:getOptionById(self.optionSelected).text or "Click here to select", self.rect.x + 10, self.rect.y + 4 + 8)
        else
            love.graphics.print("Click here to select", self.rect.x + 10, self.rect.y + 4 + 8)
        end
        love.graphics.setColor(1,1,1,1)
    else
        love.graphics.rectangle("line", self.rect.x - 4 , self.rect.y, self.rect.width + 8, self.rect.height + 8)
        love.graphics.rectangle("line", self.rect.x, self.rect.y + 4, self.rect.width, self.rect.height)
        if self:getOptionById(self.optionSelected) ~= nil then
            love.graphics.print(self:getOptionById(self.optionSelected).text or "Click here to select", self.rect.x + 10, self.rect.y + 4 + 8)
        else
            love.graphics.print("Click here to select", self.rect.x + 10, self.rect.y + 4 + 8)
        end
    end

    local newY = self.rect.y + self.rect.height + 12
    if self.show then
        -- border
        love.graphics.rectangle("line", self.rect.x - 4, self.rect.y + self.rect.height + 12, self.rect.width + 8, self.maxHeight)
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle("fill", self.rect.x - 4, self.rect.y + self.rect.height + 12, self.rect.width + 8, self.maxHeight)
        love.graphics.setColor(1,1,1,1)
        -- boxs
        for i, v in ipairs(self.options) do
            local scrollBarY = (newY - self.scrollbarPositionY)
            local ratio = ((self.rect.height + 4) * #self.options + 4) / self.maxHeight
            local scrollDownY = scrollBarY * ratio
            if newY + ((i - 1) * (self.rect.height + 4)) + (scrollBarY * ratio) - 5  < self.rect.y + self.maxHeight and newY + ((i - 1) * (self.rect.height + 4)) + (scrollBarY * ratio) > self.rect.y + self.rect.height then
                if mx > self.rect.x and mx < self.rect.x + self.rect.width and
                my > newY + 4 + ((i - 1) * (self.rect.height + 4)) + scrollDownY
                and my < newY + self.rect.height + 4 + ((i - 1) * (self.rect.height + 4)) + scrollDownY then
                    love.graphics.rectangle("fill", self.rect.x, newY + 4 + ((i - 1) * (self.rect.height + 4)) + scrollDownY, self.rect.width, self.rect.height)
                    love.graphics.setColor(0,0,0,1)
                    love.graphics.print(v.text, self.rect.x + 4, self.rect.y + 4 + (self.rect.height + 16 )+ ( (i - 1) * (self.rect.height + 4)) + scrollDownY + 2)
                    love.graphics.setColor(1,1,1,1)
                else
                    love.graphics.rectangle(
                        "line", self.rect.x,
                        self.rect.y + (self.rect.height + 16 ) + ( (i - 1) * (self.rect.height + 4)) + scrollDownY,
                        self.rect.width, self.rect.height)
                    love.graphics.setColor(0,0,0,1)
                    love.graphics.rectangle("fill", self.rect.x, newY + 4 + ((i - 1) * (self.rect.height + 4)) + scrollDownY, self.rect.width, self.rect.height)
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.print(v.text, self.rect.x + 4, self.rect.y + 4 + (self.rect.height + 16 ) + ((i - 1) * (self.rect.height + 4)) + scrollDownY + 2)
                end
            end
        end

        if (self.rect.height + 4) * #self.options + 4 > self.maxHeight then
            love.graphics.rectangle("line", self.rect.x + self.rect.width + 8, newY, 28, self.maxHeight)
            local scrollBarHeight = self.maxHeight * (self.maxHeight / ((self.rect.height + 4) * #self.options + 4))
            if mx > self.rect.x + self.rect.width + 12 and mx < self.rect.x + self.rect.width + 34 and my > self.scrollbarPositionY and my < self.scrollbarPositionY + scrollBarHeight then
                love.graphics.rectangle("fill", self.rect.x + self.rect.width + 12, self.scrollbarPositionY + 4, 20, scrollBarHeight)
            else
                love.graphics.rectangle("line", self.rect.x + self.rect.width + 12, self.scrollbarPositionY + 4, 20, scrollBarHeight)
            end
        end
    end
end

function SelectElement:change( optionId )
    self.optionSelected = optionId
    for i in ipairs(self.onChange) do
        if self.onChange[i].handler ~= nil then
            self.onChange[i].handler(self:getOptionById(optionId))
        else
            print("select element handler not specified")
        end
    end
end

function SelectElement:addOnChangeEvent( eventId, eventHandler )
    local found = false
    for i in ipairs(self.onChange) do
        if self.onChange[i] ~= nil then
            if self.onChange[i].id == eventId then
                found = true
            end
        end
    end
    if found ~= true then
        table.insert(self.onChange, #self.onChange + 1, { id = eventId, handler = eventHandler})
    end
end

function SelectElement:removeOnChangeEvent( eventId )
    for i, v in ipairs(self.onChange) do
        if v.id == eventId then
            table.remove(self.onChange, i)
        end
    end
end

function SelectElement:mousepressed(mx, my, button)
    local newY = nil
    if button == 1 then
        if mx > self.rect.x - 4 and mx < self.rect.x + self.rect.width and my > self.rect.y  and my < self.rect.y + self.rect.height then
            self.show = not self.show
        end

        local newWidth = self.rect.x + self.rect.width

        -- Take scrollbar with in count
        if (self.rect.height + 4) * #self.options + 4 > self.maxHeight then
            newWidth = self.rect.x + self.rect.width + 8 + 16
        end

        if not (mx > self.rect.x - 4 and mx < newWidth + 16 and my > self.rect.y and my < self.rect.y + self.rect.height + 12 + (self.rect.height + 4 ) * #self.options + 4) and self.show then
            self.show = not self.show
        end

        newY = self.rect.y + self.rect.height + 12
        if self.show then
            for i, v in ipairs(self.options) do
                local scrollBarY = (newY - self.scrollbarPositionY)
                local ratio = ((self.rect.height + 4) * #self.options + 4) / self.maxHeight
                local scrollDownY = scrollBarY * ratio
                if mx > self.rect.x and mx < self.rect.x + self.rect.width and
                my > newY + 4 + ((i - 1) * (self.rect.height + 4)) + scrollDownY
                and my < newY + self.rect.height + 4 + ((i - 1) * (self.rect.height + 4)) + scrollDownY then
                    self:change(self.options[i].id)
                    self.show = not self.show
                end
            end
        end

        if (self.rect.height + 4) * #self.options + 4 > self.maxHeight then
            love.graphics.rectangle("line", self.rect.x + self.rect.width + 8, self.scrollbarPositionY, 28, self.maxHeight)
            local scrollBarHeight = self.maxHeight * (self.maxHeight / ((self.rect.height + 4) * #self.options + 4))
            if mx > self.rect.x + self.rect.width + 12 and mx < self.rect.x + self.rect.width + 34 and my > self.scrollbarPositionY and my < self.scrollbarPositionY + scrollBarHeight then
                self.scrollbarGrabbed = true
            end
        end
    end
end

function SelectElement:mousereleased(mx, my, button)
    self.scrollbarGrabbed = false
end

return SelectElement
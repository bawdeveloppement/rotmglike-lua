local ButtonElement = require(_G.libDir .. "middleclass")("ButtonElement")

function ButtonElement:initialize( text, x, y )
    self.text = love.graphics.newText(love.graphics.getFont(), text)

    self.rect = {
        x = x or 0,
        y = y or 0
    }

    self.onClick = {}
end

function ButtonElement:addOnClickEvent( eventId, eventHandler )
    local found = false
    for i, event in ipairs(self.onClick) do
        if event.id == eventId then
            found = true
        end
    end
    if found ~= true then
        table.insert(self.onClick, #self.onClick + 1, { id = eventId, handler = eventHandler})
    end
end
function ButtonElement:removeOnClickEvent( eventId, eventHandler )
    for i, event in ipairs(self.onClick) do
        if event.id == eventId then
            table.remove(self.onClick, i)
        end
    end
end

function ButtonElement:click()
    for i in ipairs(self.onClick) do
        if self.onClick[i].handler ~= nil then
            self.onClick[i].handler()
        end
    end
end

function ButtonElement:draw ()
    local mx, my = love.mouse.getPosition()
    if mx > self.rect.x and mx < self.rect.x + self.text:getWidth() + 8
    and my > self.rect.y and my < self.rect.y + self.text:getHeight() + 8 then
        love.graphics.rectangle("fill", self.rect.x, self.rect.y, self.text:getWidth() + 8, self.text:getHeight() + 8)
        love.graphics.setColor(0,0,0,1)
        love.graphics.draw(self.text, self.rect.x + 2, self.rect.y + 2)
        love.graphics.setColor(1,1,1,1)
    else
        love.graphics.rectangle("line", self.rect.x, self.rect.y, self.text:getWidth() + 8, self.text:getHeight() + 8 )
        love.graphics.draw(self.text, self.rect.x + 2, self.rect.y + 2)
    end
end

function ButtonElement:mousepressed(mx, my, button)
    if button == 1 then
        if mx > self.rect.x and mx < self.rect.x + self.text:getWidth() + 8
        and my > self.rect.y and my < self.rect.y + self.text:getHeight() + 8 then
            self:click()
        end
    end
end

return ButtonElement
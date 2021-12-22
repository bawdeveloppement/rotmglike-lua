local VolumeControllerObject = require(_G.libDir .. "middleclass")("VolumeControllerObject")

function VolumeControllerObject:initialize()
    self.rect = {
        x = 50,
        y = 200,
        width = 128,
        height = 32
    }

    self.bar = {
        width = 8,
        height = 32
    }

    self.scale = 1

    self.onChange = {}
end

function VolumeControllerObject:update(...)
end

function VolumeControllerObject:draw(...)
    local mx, my = love.mouse.getPosition()

    local padding = 4 * self.scale
    local barWidth = self.bar.width * self.scale
    local barHeight = self.bar.height * self.scale
    for i = 0, 10, 1 do
        if mx > self.rect.x + (i * (barWidth + padding)) 
        and mx < self.rect.x + (i * (barWidth + padding)) + barWidth
        and my > self.rect.y and my < self.rect.y + barHeight then
            love.graphics.rectangle("line", self.rect.x + i * ( barWidth + padding ), self.rect.y, self.bar.width, self.bar.height)
        end
        if (
            mx > self.rect.x and self.rect.x + (i * 12) < mx and my > self.rect.y and my < self.rect.y + barHeight
        ) then
            love.graphics.rectangle("fill", self.rect.x + i * ( barWidth + padding ), self.rect.y, self.bar.width, self.bar.height)
        else
            if i / 10 <= love.audio.getVolume() then
                love.graphics.rectangle("fill", self.rect.x + i * ( barWidth + padding ), self.rect.y, self.bar.width, self.bar.height)
            else
                love.graphics.rectangle("line", self.rect.x + i * ( barWidth + padding ), self.rect.y, self.bar.width, self.bar.height)
            end
        end
    end
    love.graphics.rectangle(
        "line",
        self.rect.x - padding, self.rect.y - padding,
        self.rect.width + ( padding * 2 ), self.rect.height + ( padding * 2 )
    )
    love.graphics.print("0", self.rect.x - 20, self.rect.y + self.rect.height / 2 - 6)
    love.graphics.print("Volume : " .. math.floor(love.audio.getVolume() * 10) / 10, self.rect.x, self.rect.y - 24)
    love.graphics.print("1", self.rect.x + 128 + 16, self.rect.y + self.rect.height / 2 - 12)
end

function VolumeControllerObject:mousepressed (mx, my, button)
    if button == 1 then
        local padding = 4 * self.scale
        local barWidth = self.bar.width * self.scale
        for i = 0, 10, 1 do
            if mx > self.rect.x + i * (barWidth + padding) and mx < self.rect.x + i * (barWidth + padding) + barWidth
            and my > self.rect.y + 0 and my < self.rect.y + self.bar.height then
                self:setVolume(i / 10 + 0.01)
            end
        end
    end
end

function VolumeControllerObject:setVolume ( volume )
    for i in ipairs(self.onChange) do
        self.onChange[i].handler(volume)
    end
end

function VolumeControllerObject:deleteOnChangeEvent( eventId )
    for i, event in ipairs(self.onChange) do
        if event.id == eventId then
            table.remove(self.onChange, i)
        end
    end
end

function VolumeControllerObject:addOnChangeEvent( eventId, eventHandler )
    local found = false
    for i, event in ipairs(self.onChange) do
        if event.id == eventId then
            found = true
        end
    end
    if found ~= true then
        table.insert(self.onChange, #self.onChange + 1, { id = eventId, handler = eventHandler})
    end
end

return VolumeControllerObject
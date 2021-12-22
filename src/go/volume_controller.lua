local VolumeControllerObject = require(_G.libDir .. "middleclass")("VolumeControllerObject")

function VolumeControllerObject:initialize()
    self.rect = {
        x = 50,
        y = 50,
        width = 100,
        height = 100,
    }

    self.other = {
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

function VolumeControllerObject:update(dt)
    local mx, my = love.mouse.getPosition()
    for i = 0, 9, 1 do
        if mx > self.rect.x + i * 6 and mx < self.rect.x + (i * 6) + 4 and my > self.rect.y + 0 and my < self.rect.y + 16 then
            love.graphics.rectangle("fill", self.rect.x + i * 6, self.rect.y + 10 - (i + 1), 4, 6 + i + 1)
            love.graphics.rectangle("line", self.rect.x + i * 6, self.rect.y + 10 - (i + 1), 4, 6 + i + 1)
        else
            if i <= love.audio.getVolume() / 10 then
                love.graphics.rectangle("fill", self.rect.x + i * 6, self.rect.y + 10 - (i + 1), 4, 6 + i + 1)
            else
                love.graphics.rectangle("line", self.rect.x + i * 6, self.rect.y + 10 - (i + 1), 4, 6 + i + 1)
            end
        end
    end
    love.graphics.rectangle("line", self.rect.x - 2, self.rect.y - 2, 64, 20)
end

function VolumeControllerObject:draw()
    local mx, my = love.mouse.getPosition()
    for i = 0, 9, 1 do
        if mx > self.rect.x + i * 12 and mx < self.rect.x + (i * 12) + 8 and my > self.rect.y + 0 and my < self.rect.y + 32 then
            love.graphics.rectangle("fill", self.rect.x + i * 12, self.rect.y + 10 - (i + 1), 8, 12 + i + 1)
            love.graphics.rectangle("line", self.rect.x + i * 12, self.rect.y + 10 - (i + 1), 8, 12 + i + 1)
        else
            if i / 10 <= love.audio.getVolume() then
                love.graphics.rectangle("fill", self.rect.x + i * 12, self.rect.y + 10 - (i + 1), 8, 12 + i + 1)
            else
                love.graphics.rectangle("line", self.rect.x + i * 12, self.rect.y + 10 - (i + 1), 8, 12 + i + 1)
            end
        end
    end

    local padding = 4 * self.scale
    local barWidth = self.bar.width * self.scale
    for i = 0, 10, 1 do
        if mx > self.other.x + (i * (barWidth + padding)) and mx < self.other.x + (i * (barWidth + padding)) + barWidth  then
            love.graphics.rectangle("line", self.other.x + i * ( barWidth + padding ), self.other.y, self.bar.width, self.bar.height)
        end
        if (
            mx > self.other.x and self.other.x + (i * 12) < mx
        ) then
            love.graphics.rectangle("fill", self.other.x + i * ( barWidth + padding ), self.other.y, self.bar.width, self.bar.height)
        else
            if i / 10 <= love.audio.getVolume() then
                love.graphics.rectangle("fill", self.other.x + i * ( barWidth + padding ), self.other.y, self.bar.width, self.bar.height)
            else
                love.graphics.rectangle("line", self.other.x + i * ( barWidth + padding ), self.other.y, self.bar.width, self.bar.height)
            end
        end
    end
    love.graphics.rectangle(
        "line",
        self.other.x - padding, self.other.y - padding,
        self.other.width + ( padding * 2 ), self.other.height + ( padding * 2 )
    )
    love.graphics.print("0", self.other.x - 20, self.other.y + self.other.height / 2 - 6)
    love.graphics.print(math.floor(love.audio.getVolume() * 10) / 10, self.other.x + self.other.width / 2, self.other.y - 24)
    love.graphics.print("1", self.other.x + 128 + 16, self.other.y + self.other.height / 2 - 12)
end

function VolumeControllerObject:mousepressed (mx, my, button)
    if button == 1 then
        local padding = 4 * self.scale
        local barWidth = self.bar.width * self.scale
        for i = 0, 10, 1 do
            if mx > self.other.x + i * (barWidth + padding) and mx < self.other.x + i * (barWidth + padding) + barWidth
            and my > self.other.y + 0 and my < self.other.y + self.bar.height then
                self:setVolume(i / 10 + 0.01)
            end
        end
    end
end

function VolumeControllerObject:setVolume ( volume )
    for i, v in ipairs(self.onChange) do
        v.func(volume)
    end
end

function VolumeControllerObject:deleteOnChangeEvent( eventName )
    for i, v in ipairs(self.onChange) do
        if v.name == eventName then
            table.remove(self.onChange, i)
        end
    end
end

function VolumeControllerObject:addOnChangeEvent( eventName, eventFunc )
    table.insert(self.onChange, { name = eventName, func = eventFunc })
end

return VolumeControllerObject
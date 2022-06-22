
local PrefabSlot = require(_G.srcDir .. "prefabs.prefab-slot")

local GOBlacksmithInterface = require(_G.libDir .. "middleclass")("GOBlacksmithInterface");
local CharacterComponent = require(_G.srcDir .. "components.component-character")
GOBlacksmithInterface.static.name = "GOBlacksmithInterface"

function GOBlacksmithInterface:initialize ()
    local w, h = love.window:getMode()
    self.equipmentSlot = PrefabSlot:new({ x= w - 300 + 10, y= (h / 2) - 300 / 2 + 10})
    self.parchmentSlot = PrefabSlot:new({ x= w - 300 / 2 - 32 / 2, y= (h / 2) - 300 / 2 + 52 + 150 + 10 }, 25)
end


function GOBlacksmithInterface:draw( show )
    local w, h = love.window:getMode()
    if show then
        self.equipmentSlot:draw({ x= w - 300 + 10, y= (h / 2) - 300 / 2 + 10})
        love.graphics.setColor(0,0,0, 0.4)
        love.graphics.rectangle("fill", w - 300, (h / 2) - 300 / 2, 300, 300)
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.rectangle("line", w - 300, (h / 2) - 300 / 2, 300, 300)
        --description
        love.graphics.rectangle("line", w - 300 + 10, (h / 2) - 300 / 2 + 52, 280, 150)
        if self.equipmentSlot.item ~= nil then
            local descText = love.graphics.newText(_G.font1, "Stats")
            if self.equipmentSlot.item.ActivateOnEquip ~= nil then
                local lastIndex = 1
                local newHeight = 0
                for k, v in pairs(self.equipmentSlot.item.ActivateOnEquip.IncrementStat) do
                    newHeight = newHeight + descText:getHeight(lastIndex)
                    lastIndex = descText:addf({{0, 1, 0, 1}, CharacterComponent.statOffToHere[k] .. " : " .. v}, 300, "left", 0, newHeight + descText:getHeight(lastIndex))
                end
            end
            love.graphics.draw(descText, w - 300 + 10, (h / 2) - 300 / 2 + 52)
        end
        -- parchmentSlot
        self.parchmentSlot:draw({ x= w - 300 + 10, y= (h / 2) - 300 / 2 + 10})

        --button
        love.graphics.rectangle("line", w - 300 / 2 - 50, (h / 2) - 300 / 2 + 52 + 150 + 52, 100, 32)
        love.graphics.print("Forge", w - 300 / 2 - 50, (h / 2) - 300 / 2 + 52 + 150 + 52)
    end
end

function GOBlacksmithInterface:mousepressed(mx, my, button)
    local w, h = love.window:getMode()
    self.equipmentSlot:mousepressed(mx, my, button)
    self.parchmentSlot:mousepressed(mx, my, button)
    if self.equipmentSlot.item ~= nil and self.parchmentSlot.item ~= nil then
        if mx > w - 300 / 2 - 50 and mx < w - 300 / 2 - 50 + 100 and my > (h / 2) - 300 / 2 + 52 + 150 + 52 and my < (h / 2) - 300 / 2 + 52 + 150 + 52 + 32 then
            if self.equipmentSlot.item.ActivateOnEquip ~= nil then
                if self.parchmentSlot.item.ActivateOnEquip ~= nil then
                    for k, v in pairs(self.parchmentSlot.item.ActivateOnEquip.IncrementStat) do
                        if self.equipmentSlot.item.ActivateOnEquip.IncrementStat[k] ~= nil then
                            self.equipmentSlot.item.ActivateOnEquip.IncrementStat[k] = self.equipmentSlot.item.ActivateOnEquip.IncrementStat[k] + v
                        else
                            self.equipmentSlot.item.ActivateOnEquip.IncrementStat[k] = v
                        end
                    end
                end
            else
                self.equipmentSlot.item.ActivateOnEquip = {}
                self.equipmentSlot.item.ActivateOnEquip.IncrementStat = {}
                if self.parchmentSlot.item.ActivateOnEquip ~= nil then
                    for k, v in pairs(self.parchmentSlot.item.ActivateOnEquip.IncrementStat) do
                        self.equipmentSlot.item.ActivateOnEquip.IncrementStat[k] = v
                    end
                end
            end
            self.parchmentSlot.item = nil
        end
    end
end

function GOBlacksmithInterface:mousereleased(mx, my, button)
    self.equipmentSlot:mousereleased(mx, my, button)
    self.parchmentSlot:mousereleased(mx, my, button)
end




function GOBlacksmithInterface:keyreleased (key)
end


return GOBlacksmithInterface
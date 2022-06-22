local GOStatsInterface = require(_G.libDir .. "middleclass")("GOStatsInterface");

GOStatsInterface.static.name = "GOManaBar"

function GOStatsInterface:initialize()
    self.manaText = love.graphics.newText(_G.font, "")
    self.lshift = false
    self.buttonSound = love.audio.newSource("src/assets/sfx/button_click.mp3", "static");
end

local plus = {
    { x = 25, y = 345, name = "max_life" },
    { x = 25, y = 365, name = "max_mana" },
    { x = 25, y = 385, name = "attack" },
    { x = 25, y = 405, name = "defense" },
    { x = 25, y = 425, name = "wisdom" },
    { x = 25, y = 445, name = "dexterity" },
    { x = 25, y = 465, name = "speed" },
    { x = 25, y = 485, name = "vitality" },
}

function GOStatsInterface:drawPlus ( index, character)
    local mx, my = love.mouse.getPosition()
    local w, h = love.window:getMode()
    love.graphics.rectangle("line", plus[index].x - 8, h - (600 - plus[index].y)- 8, 16, 16)

    if character.statPoints > 0 then
        if mx > plus[index].x - 8 and mx < plus[index].x + 8 and my >  h - (600 - plus[index].y) - 8 and my < h - (600 - plus[index].y) + 8 then
            love.graphics.setColor(255,255,0,255)
        end
        love.graphics.rectangle("fill",  plus[index].x - 2,  h - (600 - plus[index].y) - 8, 4, 16)
        love.graphics.rectangle("fill",  plus[index].x - 8,  h - (600 - plus[index].y) - 2, 16, 4)
        love.graphics.setColor(255,255,255,255)
    end

    
end

function GOStatsInterface:mousereleased ( mx, my, button, characterComponent )
    local w, h = love.window.getMode()
    if characterComponent.statPoints > 0 then
        for i, v in ipairs(plus) do
            if mx > plus[i].x - 8 and mx < plus[i].x + 8 and my > h - (600 - plus[i].y) - 8 and my < h - (600 - plus[i].y) + 8 then
                if button == 1 then
                    if self.lshift ~= false then
                        if plus[i].name == "max_life" or plus[i].name == "max_mana" then
                            characterComponent.stats[plus[i].name].base = characterComponent.stats[plus[i].name].base + characterComponent.statPoints * 5;
                        else
                            characterComponent.stats[plus[i].name].base = characterComponent.stats[plus[i].name].base + characterComponent.statPoints;
                        end
                        characterComponent.statPoints = 0;
                        self.buttonSound.play(self.buttonSound)
                    else
                        if plus[i].name == "max_life" or plus[i].name == "max_mana" then
                            characterComponent.stats[plus[i].name].base = characterComponent.stats[plus[i].name].base + 5;
                        else
                            characterComponent.stats[plus[i].name].base = characterComponent.stats[plus[i].name].base + 1;
                        end
                        characterComponent.statPoints = characterComponent.statPoints - 1;
                        self.buttonSound.play(self.buttonSound)
                    end
                end
            end
        end
    end
end

function GOStatsInterface:keyreleased (key)
    if key == "lshift" then
        if self.lshift then
            self.lshift = false
        else
            self.lshift = true
        end
    end
end

function GOStatsInterface:draw( show, characterComponent )
    local w, h = love.window:getMode()
    if show then
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.rectangle("line", 10, h - 272, 220, 220);
        love.graphics.setColor(0, 0, 0, 0.4);
        love.graphics.rectangle("fill", 10, h - 272, 220, 220);
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.print("Player stats", 10, h - 308)
        
        local i = 0
        for k, v in pairs(characterComponent.stats) do
            if k ~= "life" and k ~= "mana" then
                local maxLife = love.graphics.newText(_G.font1, {
                    {1,1,1,1}, k .. " : " .. v.base,
                    {0,1,0,1}," + " .. v.equipment
                })
                love.graphics.draw(maxLife, 40, h - 262 + 20 * i)
                i = i + 1
            end
        end
        -- love.graphics.print("Max life : "..characterComponent.stats.max_life.base, 40, h - 262) 
        self:drawPlus(1, characterComponent)
        -- love.graphics.print("Max mana : "..characterComponent.stats.max_mana.base, 40, h - 242)
        self:drawPlus(2, characterComponent)
        -- love.graphics.print("Attack : "..characterComponent.stats.attack.base, 40, h - 222)
        self:drawPlus(3, characterComponent)
        -- love.graphics.print("Defense : "..characterComponent.stats.defense.base, 40, h - 202)
        self:drawPlus(4, characterComponent)
        -- love.graphics.print("Wisdom : "..characterComponent.stats.wisdom.base, 40, h - 182)
        self:drawPlus(5, characterComponent)
        -- love.graphics.print("Dexterity : "..characterComponent.stats.dexterity.base, 40, h - 162)
        self:drawPlus(6, characterComponent)
        -- love.graphics.print("Speed : "..characterComponent.stats.speed.base, 40, h - 142)
        self:drawPlus(7, characterComponent)
        -- love.graphics.print("Vitality : "..characterComponent.stats.vitality.base, 40, h - 122)
        self:drawPlus(8, characterComponent)
    end
end


return GOStatsInterface
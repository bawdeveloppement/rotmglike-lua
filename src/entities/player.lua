-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")
local SpriteComponent = require(_G.engineDir.."components.sprite")

local MoveComponent = require(_G.srcDir.."components.move")
local CharacterComponent = require(_G.srcDir.."components.character")
local CollisionComponent = require(_G.srcDir.."components.collision")

local function pack(...)
    return { ... }, select("#", ...)
end

local Player = require(_G.libDir .. "middleclass")("Player", Entity)

function Player:initialize( world, data )
    Entity.initialize( self, world, "Player#1", "Player", {
        { class = TransformComponent, data = { position = { x = data.position.x or 50, y = data.position.y or 50 }} },
        { class = SpriteComponent, data = { size={ w = 16, h=16 }, imageUri = "src/assets/textures/rotmg/EmbeddedAssets_playersSkins16Embed_.png"}},
        { class = CharacterComponent },
        { class = MoveComponent },
        { class = CollisionComponent }
    });

    self.buttonSound = love.audio.newSource("src/assets/sfx/button_click.mp3", "static");
end

local mx, my = 0, 0;
function Player:update(dt)
    Entity.update(self, dt);
    mx, my = love.mouse.getPosition()
end

local plus = {
    { x = 25, y = 345, name = "max_life" },
    { x = 25, y = 365, name = "max_mana" },
    { x = 25, y = 385, name = "attack" },
    { x = 25, y = 405, name = "defense" },
    { x = 25, y = 425, name = "wisdom" },
    { x = 25, y = 445, name = "dexterity" },
    { x = 25, y = 465, name = "speed" },
    { x = 25, y = 485, name = "force" },
}

local charInterface = {
    show = true
}

function Player:drawPlus ( index )
    local w, h = love.window:getMode()
    local realCamX = 0
    local realCamY = 0
    love.graphics.rectangle("line", realCamX + plus[index].x - 8, realCamY + plus[index].y - 8, 16, 16)

    local character = self.components["CharacterComponent"]
    if character.statPoints > 0 then
        if mx > plus[index].x - 8 and mx < plus[index].x + 8 and my > plus[index].y - 8 and my < plus[index].y + 8 then
            love.graphics.setColor(255,255,0,255)
        end
        love.graphics.rectangle("fill", realCamX +  plus[index].x - 2, realCamY + plus[index].y - 8, 4, 16)
        love.graphics.rectangle("fill", realCamX +  plus[index].x - 8, realCamY + plus[index].y - 2, 16, 4)
        love.graphics.setColor(255,255,255,255)
    end
end

function Player:draw()
    Entity.draw(self);

    local w, h = love.window:getMode()
    local realCamX = 0
    local realCamY = 0
    -- Interface 
    -- Quick Item Interface
    -- drawQuickSlots()
    -- Life
    local characterComponent = self.components["CharacterComponent"]
    local stats = characterComponent.stats

    love.graphics.setColor(255, 0, 0, 255);
    love.graphics.rectangle("fill", realCamX + 800 / 2 - 150, realCamY + 600 - 68, 300 * ( stats.life / stats.max_life ), 32)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", realCamX + 800 / 2 - 150, realCamY + 600 - 68, 300, 32)
    -- TODO: Find a font
    love.graphics.print(stats.life .. " / " .. stats.max_life, realCamX + 800 / 2 - 150, realCamY + 600 - 68)
    -- Mana   
    love.graphics.setColor(0,255,200,255);
    love.graphics.rectangle("fill", realCamX + 564, realCamY + 600 - 74, 64, 64)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", realCamX + 564, realCamY + 600 - 74, 64, 64 * ( stats.mana / 100 ))
    -- Experience
    love.graphics.setColor(128, 0, 128, 255);
    love.graphics.rectangle("fill", realCamX + 800 / 2 - 150, realCamY + 600 - 26, 300 * ( characterComponent.exp / characterComponent.maxExp ), 16)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", realCamX + 800 / 2 - 150, realCamY + 600 - 26, 300, 16)

    -- PlAYER
    if charInterface.show then
        -- Button
        love.graphics.setColor(128, 0, 128, 255);
        love.graphics.rectangle("fill", realCamX + 10, realCamY + 600 - 32 - 10, 32, 32)

        -- INTERFACE
        love.graphics.setColor(255, 255, 255, 255);
        love.graphics.rectangle("line", realCamX + 10, realCamY + 600 - 272, 220, 220);
        love.graphics.print("Player stats", realCamX + 10, realCamY + 308)
        love.graphics.print("Max life : "..stats.max_life, realCamX + 40, realCamY + 338)
        self:drawPlus(1)
        love.graphics.print("Max mana : "..stats.max_mana, realCamX + 40, realCamY + 358)
        self:drawPlus(2)
        love.graphics.print("Attack : "..stats.attack, realCamX + 40, realCamY + 378)
        self:drawPlus(3)
        love.graphics.print("Defense : "..stats.defense, realCamX + 40, realCamY + 398)
        self:drawPlus(4)
        love.graphics.print("Wisdom : "..stats.wisdom, realCamX + 40, realCamY + 418)
        self:drawPlus(5)
        love.graphics.print("Dexterity : "..stats.dexterity, realCamX + 40, realCamY + 438)
        self:drawPlus(6)
        love.graphics.print("Speed : "..stats.speed, realCamX + 40, realCamY + 458)
        self:drawPlus(7)
        love.graphics.print("Force : "..stats.force, realCamX + 40, realCamY + 478)
        self:drawPlus(8)
    else
        love.graphics.setColor(255, 255, 255, 255);
        love.graphics.print("C", realCamX +16, realCamY + 600-32)
        love.graphics.rectangle("line", realCamX + 10, realCamY + 600 - 32 - 10, 32, 32)
    end
end

local lshift = false
function Player:mousepressed(mousex, mousey, button)
    Entity.mousepressed(self, mousex, mousey, button)

    local characterComponent = self.components["CharacterComponent"]
    if characterComponent.statPoints > 0 then
        for i, v in ipairs(plus) do
            if mousex > plus[i].x - 8 and mousex < plus[i].x + 8 and mousey > plus[i].y - 8 and mousey < plus[i].y + 8 then
                if button == 1 then
                    if lshift ~= false then
                        if plus[i].name == "max_life" or plus[i].name == "max_mana" then
                            characterComponent.stats[plus[i].name] = characterComponent.stats[plus[i].name] + characterComponent.statPoints * 5;
                        else
                            characterComponent.stats[plus[i].name] = characterComponent.stats[plus[i].name] + characterComponent.statPoints;
                        end
                        characterComponent.statPoints = 0;
                        self.buttonSound.play(self.buttonSound)
                    else
                        if plus[i].name == "max_life" or plus[i].name == "max_mana" then
                            characterComponent.stats[plus[i].name] = characterComponent.stats[plus[i].name] + 5;
                        else
                            characterComponent.stats[plus[i].name] = characterComponent.stats[plus[i].name] + 1;
                        end
                        characterComponent.statPoints = characterComponent.statPoints - 1;
                        self.buttonSound.play(self.buttonSound)
                    end
                end
            end
        end
    end
end

function Player:keypressed(key)
    Entity.keypressed(self, key)
    if key == "lshift" then lshift = true end
    -- if key == "b" then
    --     if bagInterface.show == false then
    --         bagInterface.show = true
    --         charInterface.show = false
    --     else
    --         bagInterface.show = false
    --     end
    if key == "c" then
        if charInterface.show then
            charInterface.show = false
        else
            charInterface.show = true
            -- bagInterface.show = false
        end
    end
end

function Player:keyreleased(...)
    Entity.keyreleased(self, ...)
    local t = pack(...)
    if t.key == "lshift" then lshift = true end
end

return Player
-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")
local SpriteComponent = require(_G.engineDir.."components.sprite")
local CollisionComponent = require(_G.engineDir.."components.collision")

local MoveComponent = require(_G.srcDir.."components.move")
local CharacterComponent = require(_G.srcDir.."components.character")
local PlayerComponent = require(_G.srcDir.."components.player")

local Projectile = require(_G.srcDir .. "entities.projectile");

local function pack(...)
    return { ... }, select("#", ...)
end

local Player = require(_G.libDir .. "middleclass")("Player", Entity)

function Player:initialize( world, data )
    Entity.initialize( self, world, "Player#1", "Player", {
        { class = TransformComponent, data = { position = { x = data.position.x or 50, y = data.position.y or 50 }} },
        { class = SpriteComponent, data = { size={ w = 16, h=16 }, imageUri = "src/assets/textures/rotmg/EmbeddedAssets_playersSkins16Embed_.png"}},
        { class = CollisionComponent },
        { class = CharacterComponent, data = { isPlayer = true } },
        { class = MoveComponent },
        { class = PlayerComponent },
    });

    self.bag = {}

    self.audio = {
        level_up = love.audio.newSource("src/assets/sfx/level_up.mp3", "static")
    }

    self:bindPlaySoundOnLevelUp()
    self:bindPlaySoundOnDeath()

    local characterComponent = self:getComponent("CharacterComponent")
    self.buttonSound = love.audio.newSource("src/assets/sfx/button_click.mp3", "static");
    self.healthText = love.graphics.newText(_G.font, ""..characterComponent.stats.life .. " / " .. characterComponent.stats.max_life)
    self.manaText = love.graphics.newText(_G.font, ""..characterComponent.stats.mana .. " / " .. characterComponent.stats.max_mana)
    self.expText = love.graphics.newText(_G.font, ""..characterComponent.exp .. " / " .. characterComponent.max_exp)
    
end

function Player:bindPlaySoundOnLevelUp()
    self:getComponent("CharacterComponent"):addOnLevelUp("playsound", function ( m )
        if self.audio.level_up:isPlaying() then
            self.audio.level_up:stop()
            self.audio.level_up:play()
        else
            self.audio.level_up:play()
        end
    end)
end

function Player:bindPlaySoundOnDeath()
    self:getComponent("CharacterComponent"):addOnDeath("ondeath", function ( m )
        if m.audio.death:isPlaying() then
            m.audio.death:stop()
            m.audio.death:play()
        else
            m.audio.death:play()
        end
    end)
end

local mx, my = 0, 0;
function Player:update(dt)
    Entity.update(self, dt);
    mx, my = love.mouse.getPosition()

    local position = self:getComponent("TransformComponent").position
    if love.mouse.isDown(1) then
        local velx = math.cos(math.atan2(position.y - my, position.x - mx))
        local vely = math.sin(math.atan2(position.y - my, position.x - mx));
        self.world:addEntity( Projectile:new(self.world, { ownerId = self.id, x = position.x, y = position.y, dx = velx, dy = vely }))
        -- self.sound.fire.play(self.sound.fire)
    end
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
    show = false
}

local bagInterface = {
    show = false
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
    local selfPosition = self.components["TransformComponent"].position
    local stats = characterComponent.stats

    local ww, wh = love.window.getMode()
    self.healthText:set(""..characterComponent.stats.life .. " / " .. characterComponent.stats.max_life)
    self.manaText:set(""..characterComponent.stats.mana .. "\n / \n" .. characterComponent.stats.max_mana)
    self.expText:set(""..characterComponent.exp .. " / " .. characterComponent.max_exp)

    love.graphics.setColor(255, 0, 0, 255);
    love.graphics.rectangle("fill", realCamX + 800 / 2 - 150, realCamY + 600 - 68, 300 * ( stats.life / stats.max_life ), 32)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", realCamX + 800 / 2 - 150, realCamY + 600 - 68, 300, 32)
    love.graphics.draw(self.healthText,  ww / 2 - self.healthText:getWidth() / 2, 532 + (self.healthText:getHeight() / 2))
    -- Mana   
    love.graphics.setColor(0,255,200,255);
    love.graphics.rectangle("fill", realCamX + 564, realCamY + 600 - 74, 64, 64)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", realCamX + 564, realCamY + 600 - 74, 64, 64 * ( stats.mana / 100 ))
    love.graphics.draw(self.manaText,  564 + 32 - self.manaText:getWidth(), 526 + (self.manaText:getHeight() / 2))
    -- Experience
    love.graphics.setColor(128, 0, 128, 255);
    love.graphics.rectangle("fill", realCamX + 800 / 2 - 150, realCamY + 600 - 26, 300 * ( characterComponent.exp / characterComponent.max_exp ), 16)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", realCamX + 800 / 2 - 150, realCamY + 600 - 26, 300, 16)
    love.graphics.draw(self.expText,  ww / 2 - self.expText:getWidth() / 2, 576)

    -- PlAYER
    if charInterface.show then
        -- Button
        love.graphics.setColor(128, 0, 128, 255);
        love.graphics.rectangle("fill", realCamX + 10, realCamY + 600 - 32 - 10, 32, 32)

        -- INTERFACE
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.rectangle("line", realCamX + 10, realCamY + 600 - 272, 220, 220);
        love.graphics.setColor(0, 0, 0, 0.4);
        love.graphics.rectangle("fill", realCamX + 10, realCamY + 600 - 272, 220, 220);
        love.graphics.setColor(1, 1, 1, 1);
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

    -- BAG
    if bagInterface.show then
        -- Bag Icon
        love.graphics.setColor(128, 0, 128, 255);
        love.graphics.rectangle("fill", 20 + 32, 600 - 32 - 10, 32, 32)
        -- Bag Interface
        love.graphics.setColor(255, 255, 255, 255);
        love.graphics.rectangle("line", 10, 600- 52 - 220, 220, 220);
        love.graphics.setColor(0, 0, 0, 0.4);
        love.graphics.rectangle("fill", 10, 600- 52 - 220, 220, 220);
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.print("Bag : "..#self.bag.." items.", 10, 600-52-240)
        for y = 1, 5, 1 do
            for x = 1, 5, 1 do
                love.graphics.rectangle("line", 20 + (10 + 32) * (x - 1), (600 - 94 - 210 ) + 42 * y, 32, 32)
            end
        end
        love.graphics.print("Bag : "..#self.bag.." items.", 10, 600-52-240)
    else
        love.graphics.setColor(255, 255, 255, 255);
        love.graphics.print("B", 64, 600-32)
        love.graphics.rectangle("line", 20 + 32, 600 - 32 - 10, 32, 32)
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
    if key == "b" then
        if bagInterface.show == false then
            bagInterface.show = true
            charInterface.show = false
        else
            bagInterface.show = false
        end
    end
    if key == "c" then
        if charInterface.show then
            charInterface.show = false
            bagInterface.show = true
        else
            charInterface.show = true
            bagInterface.show = false
        end
    end
end

function Player:keyreleased(key)
    Entity.keyreleased(self, key)

    if key  == "lshift" then lshift = false end
end

return Player
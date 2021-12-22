-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")
local SpriteComponent = require(_G.engineDir.."components.sprite")
local CollisionComponent = require(_G.engineDir.."components.collision")

local MoveComponent = require(_G.srcDir.."components.move")
local CharacterComponent = require(_G.srcDir.."components.character")

local Projectile = require(_G.srcDir .. "entities.projectile");

local Container = require(_G.srcDir .. "go.container");

local function pack(...)
    return { ... }, select("#", ...)
end

local Player = require(_G.libDir .. "middleclass")("Player", Entity)

function Player:initialize( world, data )
    Entity.initialize(self, world, "Player#1", "Player", {
        { class = TransformComponent, data = { position = { x = data.position.x or 50, y = data.position.y or 50 }} },
        { class = SpriteComponent, data = { rect={ width = 32 , height= 32 }, tile = { width = 16, height = 16 }, imageUri = "src/assets/textures/rotmg/EmbeddedAssets_playersSkins16Embed_.png"}},
        { class = CollisionComponent },
        { class = CharacterComponent, data = { isPlayer = true } },
        { class = MoveComponent },
    });

    self.bag = Container:new(20)

    for i = 1, 9, 1 do
        local itemToLoot = love.math.random(1, #_G.dbObject.Equipments)
        self.bag:addItem(_G.dbObject.Equipments[itemToLoot])
    end

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

    self.autoFire = false
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
function Player:update(...)
    Entity.update(self, ...);
    mx, my = love.mouse.getPosition()

    local position = self:getComponent("TransformComponent").position
    if love.mouse.isDown(1) or self.autoFire == true then
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
    { x = 25, y = 485, name = "vitality" },
}

local charInterface = {
    show = false
}

local bagInterface = {
    show = false
}

function Player:drawPlus ( index )
    local w, h = love.window:getMode()
    love.graphics.rectangle("line", plus[index].x - 8, h - (600 - plus[index].y)- 8, 16, 16)

    local character = self.components["CharacterComponent"]
    if character.statPoints > 0 then
        if mx > plus[index].x - 8 and mx < plus[index].x + 8 and my >  h - (600 - plus[index].y) - 8 and my < h - (600 - plus[index].y) + 8 then
            love.graphics.setColor(255,255,0,255)
        end
        love.graphics.rectangle("fill",  plus[index].x - 2,  h - (600 - plus[index].y) - 8, 4, 16)
        love.graphics.rectangle("fill",  plus[index].x - 8,  h - (600 - plus[index].y) - 2, 16, 4)
        love.graphics.setColor(255,255,255,255)
    end
end

local quickSlots = {
    { type = "quick_slot", key="f", item = nil },
    { type = "quick_slot", key="a", item = nil },
    { type = "quick_slot", key="e", item  = nil },
    { type = "head", item = nil },
    { type = "spell", item = nil },
    { type = "chest", item = nil },
    { type = "ring", item = nil },
}
--#endregion
local function drawQuickSlots ()
    local w, h = love.window.getMode()
    for i, v in ipairs(quickSlots) do
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("line", w / 2 - 150 + (i - 1) * 42, h - 110, 32, 32)
        love.graphics.setColor(0,0,0,0.4)
        love.graphics.rectangle("fill", w / 2 - 150 + (i - 1) * 42, h - 110, 32, 32)
        love.graphics.setColor(1,1,1,1)
        if quickSlots[i].item ~= nil and quickSlots[i].quantity ~= 0 and quickSlots[i].quantity ~= nil then
            love.graphics.print(""..quickSlots[i].quantity, w / 2 - 150 + (i - 1) * 42, h - 110)
            local quad = love.graphics.newQuad(
                0,
                0,
                64, 32,
                quickSlots[i].item.texture:getDimensions()
            )
            love.graphics.draw(
                quickSlots[i].item.texture,
                quad,
                w / 2 + (i - 1) * 42,
                h - 110,
                0,
                1.5, 1.5,
                0, 0,
                0, 0
            )
        end
    end
end



function Player:draw()
    Entity.draw(self);

    local w, h = love.window:getMode()
    local realCamX = 0
    local realCamY = 0
    -- Interface
    -- Quick Item Interface
    drawQuickSlots()
    -- Life
    local characterComponent = self.components["CharacterComponent"]
    local selfPosition = self.components["TransformComponent"].position
    local stats = characterComponent.stats

    self.healthText:set("".. math.floor(characterComponent.stats.life * 10) / 10 .. " / " .. characterComponent.stats.max_life)
    self.manaText:set(""..characterComponent.stats.mana .. "\n / \n" .. characterComponent.stats.max_mana)
    self.expText:set(""..characterComponent.exp .. " / " .. characterComponent.max_exp)

    love.graphics.setColor(255, 0, 0, 255);
    love.graphics.rectangle("fill", w / 2 - 150, h - 68, 300 * ( stats.life / stats.max_life ), 32)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", w / 2 - 150, h - 68, 300, 32)
    love.graphics.draw(self.healthText,  w / 2 - self.healthText:getWidth() / 2, h - 68 + (self.healthText:getHeight() / 2))
    -- Mana
    love.graphics.setColor(0,255,200,255);
    love.graphics.rectangle("fill", w / 2 + 164, h - 74, 64, 64)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", w / 2 + 164, h - 74, 64, 64 * ( stats.mana / 100 ))
    love.graphics.draw(self.manaText,  w / 2 + 164 + 16 + 32 - self.manaText:getWidth(),h - 74 + (self.manaText:getHeight() / 2))
    -- Experience
    love.graphics.setColor(0, 0, 0, 0.4);
    love.graphics.rectangle("fill", w / 2 - 150, h - 26, 300, 16)
    love.graphics.setColor(128/255, 0, 128/255, 1);
    love.graphics.rectangle("fill", w / 2 - 150, h - 26, 300 * ( characterComponent.exp / characterComponent.max_exp ), 16)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", w / 2 - 150, h - 26, 300, 16)
    love.graphics.draw(self.expText,  w / 2 - self.expText:getWidth() / 2, h - 24)

    -- PlAYER
    if charInterface.show then
        -- Button
        love.graphics.setColor(128 / 255, 0, 128 / 255, 255);
        love.graphics.rectangle("fill", 10, h - 32 - 10, 32, 32)
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.print("C", 16, h - 32)
        love.graphics.rectangle("line", 10, h - 32 - 10, 32, 32)

        -- INTERFACE
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.rectangle("line", 10, h - 272, 220, 220);
        love.graphics.setColor(0, 0, 0, 0.4);
        love.graphics.rectangle("fill", 10, h - 272, 220, 220);
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.print("Player stats", 10, 308)
        love.graphics.print("Max life : "..stats.max_life, 40, h - 262) 
        self:drawPlus(1)
        love.graphics.print("Max mana : "..stats.max_mana, 40, h - 242)
        self:drawPlus(2)
        love.graphics.print("Attack : "..stats.attack, 40, h - 222)
        self:drawPlus(3)
        love.graphics.print("Defense : "..stats.defense, 40, h - 202)
        self:drawPlus(4)
        love.graphics.print("Wisdom : "..stats.wisdom, 40, h - 182)
        self:drawPlus(5)
        love.graphics.print("Dexterity : "..stats.dexterity, 40, h - 162)
        self:drawPlus(6)
        love.graphics.print("Speed : "..stats.speed, 40, h - 142)
        self:drawPlus(7)
        love.graphics.print("Vitality : "..stats.vitality, 40, h - 122)
        self:drawPlus(8)
    else
        love.graphics.setColor(0, 0, 0, 0.4);
        love.graphics.rectangle("fill", 10, 600 - 32 - 10, 32, 32)
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.print("C", 16, h-32)
        love.graphics.rectangle("line", 10, h - 32 - 10, 32, 32)
    end

    -- BAG
    if bagInterface.show then
        -- Bag Icon
        self.bag:draw()
        love.graphics.setColor(128/255, 0, 128/255, 255);
        love.graphics.rectangle("fill", 20 + 32, h - 32 - 10, 32, 32)
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.print("B", 65, h-32)
        love.graphics.rectangle("line", 20 + 32, h - 32 - 10, 32, 32)
    else
        love.graphics.setColor(0, 0, 0, 0.4);
        love.graphics.rectangle("fill", 20 + 32, h - 32 - 10, 32, 32)
        love.graphics.setColor(1, 1, 1, 1);
        love.graphics.print("B", 65, h-32)
        love.graphics.rectangle("line", 20 + 32, h - 32 - 10, 32, 32)
    end
end

local lshift = false
function Player:mousepressed(mousex, mousey, button)
    Entity.mousepressed(self, mousex, mousey, button)
    self.bag:mousepressed(mousex, mousey, button)
    local w, h = love.window.getMode()
    local characterComponent = self.components["CharacterComponent"]
    if characterComponent.statPoints > 0 then
        for i, v in ipairs(plus) do
            if mousex > plus[i].x - 8 and mousex < plus[i].x + 8 and mousey > h - (600 - plus[i].y) - 8 and mousey < h - (600 - plus[i].y) + 8 then
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

    if key == "i" then
        self.autoFire = not self.autoFire
    end
    if key == "k" then
        local itemToLoot = love.math.random(1, #_G.dbObject.Equipments)
        self.bag:addItem(_G.dbObject.Equipments[itemToLoot])
    end
    if key == "j" then
        self.bag:removeFirstItem()
    end
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
        if charInterface.show == false then
            charInterface.show = true
            bagInterface.show = false
        else
            charInterface.show = false
        end
    end
end

function Player:keyreleased(key)
    Entity.keyreleased(self, key)
    if key  == "lshift" then lshift = false end
end

return Player
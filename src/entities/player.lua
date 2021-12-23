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
        { class = SpriteComponent, data = { rect={ width = 32 , height= 32 }, tile = { width = 16, height = 16 }, imageUri = "src/assets/textures/playersSkins16.png"}},
        { class = CollisionComponent },
        { class = CharacterComponent, data = { isPlayer = true } },
        { class = MoveComponent },
    });

    self.itemInMouse = {
        item = nil,
        quantity = 0,
        lastIndex = nil
    }

    self.quickSlots = {
        { slotTypes = 0, key="f", type = "quick_slot", item = nil },
        { slotTypes = 0, key="a", type = "quick_slot", item = nil },
        { slotTypes = 0, key="e", type = "quick_slot", item  = nil },
        { slotTypes = { 1, 8, 2, 3, 17, 23, 24 }, key="1", type = "weapon", item = nil },
        { slotTypes = { 4, 5, 11, 12, 13, 15, 16, 18, 19, 20, 21, 22, 25 }, key="2", type = "spell", item = nil },
        { slotTypes = { 6, 7, 14}, key="3", type = "chest", item = nil },
        { slotTypes = { 9 }, key="4", type = "ring", item = nil },
    }

    self.bag = Container:new(20, 0, 0, self)

    for i = 1, 9, 1 do
        local itemToLoot = love.math.random(1, #_G.dbObject.Equipments)
        self.bag:addItemInFirstEmptySlot(_G.dbObject.Equipments[itemToLoot], 1)
    end

    self.audio = {
        fire = nil,
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

function Player:update(...)
    Entity.update(self, ...);
    local mx, my = love.mouse.getPosition()
    local w, h = love.window.getMode()

    local position = self:getComponent("TransformComponent").position
    if love.mouse.isDown(1) or self.autoFire == true then
        local velx = math.cos(math.atan2(position.y - my, position.x - mx))
        local vely = math.sin(math.atan2(position.y - my, position.x - mx));
        if self.quickSlots[4].item ~= nil then
            if self.quickSlots[4].item.Projectile ~= nil then
                self.world:addEntity(
                    Projectile:new(
                        self.world,
                        {
                            projectileId = self.quickSlots[4].item.Projectile.ObjectId,
                            damage = {
                                minDamage = self.quickSlots[4].item.Projectile.MinDamage,
                                maxDamage = self.quickSlots[4].item.Projectile.MaxDamage
                            },
                            sound = self.quickSlots[4].item.Sound,
                            ownerId = self.id,
                            x = position.x,
                            y = position.y,
                            dx = velx,
                            dy = vely
                        }
                    )
                )
            else
                self.world:addEntity( Projectile:new(self.world, { ownerId = self.id, x = position.x, y = position.y, dx = velx, dy = vely, sound = self.quickSlots[4].item.Sound }))
            end
        else
            self.world:addEntity( Projectile:new(self.world, { ownerId = self.id, x = position.x, y = position.y, dx = velx, dy = vely }))
        end
        -- self.sound.fire.play(self.sound.fire)
    end

    local bagRect = self.bag:getRect()
    if  ( mx > bagRect.x and mx < bagRect.x + bagRect.width and my > bagRect.y and my < bagRect.y + bagRect.height ~= nil) or 
        ( mx > w / 2 - 150 and mx < w / 2 - 150 + 300 and my > h - 110 and my < h - 110 + 32) then
        self.mouseIsHoverContainer = true
    else
        self.mouseIsHoverContainer = false
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
    local mx, my = love.mouse.getPosition()
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

--#endregion
function Player:drawQuickSlots ()
    local w, h = love.window.getMode()
    for i, v in ipairs(self.quickSlots) do
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("line", w / 2 - 150 + (i - 1) * 42, h - 110, 32, 32)
        love.graphics.setColor(0,0,0,0.4)
        love.graphics.rectangle("fill", w / 2 - 150 + (i - 1) * 42, h - 110, 32, 32)
        love.graphics.setColor(1,1,1,1)
        if self.quickSlots[i].item ~= nil then
            local item = self.quickSlots[i].item;
            if item.Texture ~= nil then
                local image = _G.xle.ResourcesManager:getTexture(item.Texture.File);
                if image ~= nil then
                    local imageW, imageH = image:getDimensions()
                    local quad = love.graphics.newQuad(
                        8 * (tonumber(item.Texture.Index, 16) % (imageW / 8)),
                        math.floor(tonumber(item.Texture.Index, 16) / (imageW / 8)) * 8,
                        8,
                        8,
                        imageW, imageH
                    )
                    love.graphics.draw(image, quad, w / 2 - 150 + (i - 1) * 42,  h - 110, 0, 4);
                else
                    love.graphics.rectangle("fill", w / 2 - 150 + (i - 1) * 42,  h - 110, 32, 32)
                end
            else
                love.graphics.rectangle("fill", w / 2 - 150 + (i - 1) * 42,  h - 110, 32, 32)
            end
            love.graphics.print(""..self.quickSlots[i].quantity, w / 2 - 150 + (i - 1) * 42, h - 110)
        end
    end
end



function Player:drawItemInMouse()
    if self.itemInMouse then
        local mx, my = love.mouse.getPosition()
        if self.itemInMouse.item ~= nil then
            if self.itemInMouse.item.Texture ~= nil then
                local image = _G.xle.ResourcesManager:getTexture(self.itemInMouse.item.Texture.File);
                if image ~= nil then
                    local imageW, imageH = image:getDimensions()
                    local quad = love.graphics.newQuad(
                        8 * (tonumber(self.itemInMouse.item.Texture.Index, 16) % (imageW / 8)),
                        math.floor(tonumber(self.itemInMouse.item.Texture.Index, 16) / (imageW / 8)) * 8,
                        8,
                        8,
                        imageW, imageH
                    )
                    love.graphics.draw(image, quad, mx,  my, 0, 4);
                end
            else
                love.graphics.rectangle("fill", mx, my, 32, 32)
            end
            love.graphics.print(""..self.itemInMouse.quantity, mx + 42, my)
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
    self:drawQuickSlots()
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
        love.graphics.print("Player stats", 10, h - 308)
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
        love.graphics.rectangle("fill", 10, h - 32 - 10, 32, 32)
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

    self:drawItemInMouse()
end

local lshift = false
function Player:mousepressed(...)
    Entity.mousepressed(self, ...)
    self.bag:mousepressed(...)

    local mx, my, button = ...
    local w, h = love.window.getMode()
    local characterComponent = self.components["CharacterComponent"]
    if characterComponent.statPoints > 0 then
        for i, v in ipairs(plus) do
            if mx > plus[i].x - 8 and mx < plus[i].x + 8 and my > h - (600 - plus[i].y) - 8 and my < h - (600 - plus[i].y) + 8 then
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

    if button == 1 then
        for i, v in ipairs(self.quickSlots) do
            if mx > w / 2 - 150 + (i - 1) * 42 and mx < w / 2 - 150 + (i - 1) * 42 + 32 and my > h - 110 and my < h - 110 + 32 then
                if self.itemInMouse.item == nil and self.quickSlots[i].item ~= nil then
                    self.itemInMouse.item = self.quickSlots[i].item
                    self.itemInMouse.quantity = self.quickSlots[i].quantity
                    self.itemInMouse.lastIndex = {
                        origin = "quickslot",
                        value = i
                    }
                    self.quickSlots[i].item = nil
                    self.quickSlots[i].quantity = 0
                end
            end
        end
    end
end

function Player:canPutInQuickSlot( slotId, item)
    if self.quickSlots[slotId] ~= nil then
        if type(self.quickSlots[slotId].slotTypes) == "table" then
            local slotTypeEqual = false
            for i, v in ipairs(self.quickSlots[slotId].slotTypes) do
                if tostring(v) == item.SlotType then
                    slotTypeEqual = true
                end
            end
            return slotTypeEqual
        else
            if self.quickSlots[slotId].slotTypes == 0 then
                return true
            else
                return false
            end
        end
    else
        return false
    end
end

function Player:mousereleased(...)
    self.bag:mousereleased(...)
    local mx, my, button = ...
    local w, h = love.window.getMode()
    if button == 1 then
        for i, v in ipairs(self.quickSlots) do
            if mx > w / 2 - 150 + (i - 1) * 42 and mx < w / 2 - 150 + (i - 1) * 42 + 32 and my > h - 110 and my < h - 110 + 32 then
                if self.itemInMouse.item ~= nil then
                    if self.quickSlots[i].item == nil then
                        if self:canPutInQuickSlot(i, self.itemInMouse.item) then
                            self.quickSlots[i].item = self.itemInMouse.item
                            self.quickSlots[i].quantity = self.itemInMouse.quantity
                            self.itemInMouse = {
                                item = nil,
                                quantity = 0,
                                lastIndex = nil
                            }
                        else
                            if self.itemInMouse.lastIndex.origin == "bag" then
                               self.bag:setItemInSlotId(self.itemInMouse.lastIndex.value, self.itemInMouse.item, self.itemInMouse.quantity)
                               self.itemInMouse = {
                                   item = nil,
                                   quantity = 0,
                                   lastIndex = nil
                               }
                            end
                        end
                    elseif self.quickSlots[i].item ~= nil then
                        local old = {
                            item = self.quickSlots[i].item,
                            quantity = self.quickSlots[i].quantity
                        }
                        self.quickSlots[i].item = self.itemInMouse.item
                        self.quickSlots[i].quantity = self.itemInMouse.quantity
                        if self.itemInMouse.lastIndex ~= nil then
                            if self.itemInMouse.lastIndex.origin == "quickslot" then
                                self.quickSlots[self.itemInMouse.lastIndex.value] = old
                            else
                                self.bag:setItemInSlotId(self.itemInMouse.lastIndex.value, old.item, old.quantity)
                            end
                        end
                        self.itemInMouse = {
                            item = nil,
                            quantity = 0,
                            lastIndex = nil
                        }
                    end
                end
            else
                if not self.mouseIsHoverContainer then
                    if self.itemInMouse.item ~= nil then
                        if self.itemInMouse.lastIndex.origin == "quickslot" then
                            self.quickSlots[self.itemInMouse.lastIndex.value] = {
                                item = self.itemInMouse.item,
                                quantity = self.itemInMouse.quantity
                            }
                            self.itemInMouse.item = nil
                            self.itemInMouse.quantity = 0
                            self.itemInMouse.lastIndex = nil
                            _G.errorAudio:play()
                        elseif self.itemInMouse.lastIndex.origin == "bag" then
                            self.bag:setItemInSlotId(self.itemInMouse.lastIndex.value, self.itemInMouse.item, self.itemInMouse.quantity)
                            self.itemInMouse.item = nil
                            self.itemInMouse.quantity = 0
                            self.itemInMouse.lastIndex = nil
                            _G.errorAudio:play()
                        end
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
        self.bag:addItemInFirstEmptySlot(_G.dbObject.Equipments[itemToLoot])
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
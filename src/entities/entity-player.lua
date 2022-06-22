-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")
local SpriteComponent = require(_G.engineDir.."components.sprite")
local CollisionComponent = require(_G.engineDir.."components.collision")

local MoveComponent = require(_G.srcDir.."components.component-move")
local CharacterComponent = require(_G.srcDir.."components.component-character")
local CameraComponent = require(_G.srcDir.."components.component-camera")
local PlayerComponent = require(_G.srcDir.."components.component-player")

local Projectile = require(_G.srcDir .. "entities.entity-projectile");

local Container = require(_G.srcDir .. "prefabs.prefab-container");

local function pack(...)
    return { ... }, select("#", ...)
end

local Player = require(_G.libDir .. "middleclass")("Player", Entity)

function Player:initialize( world, data )
    Entity.initialize(self, world, "Player#1", "Player", {
        { class = TransformComponent, data = { position = { x = data.position.x or 50, y = data.position.y or 50 }} },
        { class = SpriteComponent, data = { rect={ width = 32 , height= 32 }, tile = { width = 16, height = 16 }, imageUri = "src/assets/textures/playerskins16.png"}},
        { class = CollisionComponent, data = { rect={ width = 32 , height= 32 }}},
        { class = CharacterComponent, data = { isPlayer = true } },
        { class = MoveComponent },
        { class = CameraComponent },
        { class = PlayerComponent }
    });



    self.quickSlots = {
        { slotTypes = 0, key="f", type = "quick_slot", item = nil },
        { slotTypes = 0, key="a", type = "quick_slot", item = nil },
        { slotTypes = 0, key="e", type = "quick_slot", item = nil },
        { slotTypes = { 1, 8, 2, 3, 17, 23, 24 }, key="1", type = "weapon", item = nil },
        { slotTypes = { 4, 5, 11, 12, 13, 15, 16, 18, 19, 20, 21, 22, 25 }, key="2", type = "spell", item = nil },
        { slotTypes = { 6, 7, 14}, key="3", type = "chest", item = nil },
        { slotTypes = { 9 }, key="4", type = "ring", item = nil },
    }

    self.inventory = Container:new(20, 0, 0, self)

    self.groundBag = Container:new(10, 0, 0, self)
    -- self.groundBag.rect.y = 77 - self.bag.rect.height - self.groundBag.rect.height

    for i = 1, 9, 1 do
        local itemToLoot = love.math.random(1, #_G.dbObject.Equipments)
        self.inventory:addItemInFirstEmptySlot(_G.dbObject.Equipments[itemToLoot], 1)
    end

    self.audio = {
        fire = nil,
        level_up = love.audio.newSource("src/assets/sfx/level_up.mp3", "static")
    }

    self:bindPlaySoundOnLevelUp()
    self:bindPlaySoundOnDeath()

    local characterComponent = self:getComponent("CharacterComponent")

    self.autoFire = false

    self.inCollisionWithBagEntities = {}
    self.showBagIndex = 1
end


local charInterface = {
    show = false
}

local bagInterface = {
    show = false
}

function Player:bindPlaySoundOnLevelUp()
    self:getComponent("CharacterComponent"):addOnLevelUp("playsound", function ( m )
        if self.audio.level_up:isPlaying() then
            self.audio.level_up:stop();
            self.audio.level_up:play();
        else
            self.audio.level_up:play();
        end
    end)
end

function Player:bindPlaySoundOnDeath()
    self:getComponent("CharacterComponent"):addOnDeath("ondeath", function ( m )
        if m.audio.death:isPlaying() then
            m.audio.death:stop();
            m.audio.death:play();
        else
            m.audio.death:play();
        end
    end)
end

function Player:update(...)
    Entity.update(self, ...);
    local mx, my = _G.camera:mousePosition()
    local w, h = love.window.getMode()

    local position = self:getComponent("TransformComponent").position
    -- SHOOT
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
                            lifeTimeMs = self.quickSlots[4].item.Projectile.LifetimeMS,
                            speed = self.quickSlots[4].item.Projectile.Speed,
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
    --[[
        local bagRect = self.bag:getRect()
        if  ( mx > bagRect.x and mx < bagRect.x + bagRect.width and my > bagRect.y and my < bagRect.y + bagRect.height ~= nil) or 
            ( mx > w / 2 - 150 and mx < w / 2 - 150 + 300 and my > h - 110 and my < h - 110 + 32) then
            self.mouseIsHoverContainer = true
        else
            self.mouseIsHoverContainer = false
        end

    ]]--

    
    local selfPosition = self.components["TransformComponent"].position
    local searchBagResult = self.world:getEntitiesByComponentName("ContainerComponent")
    local inCollisionWithBagEntities = {}
    for i, v in ipairs(searchBagResult) do
        bagPos = v:getComponent("TransformComponent").position
        bagRect = v:getComponent("CollisionComponent").rect
        
        if selfPosition.x > bagPos.x and selfPosition.x < bagPos.x + bagRect.width and selfPosition.y > bagPos.y and selfPosition.y < bagPos.y + bagRect.height then
            table.insert(inCollisionWithBagEntities, #inCollisionWithBagEntities + 1, v)
        end
    end

    self.inCollisionWithBagEntities = inCollisionWithBagEntities

    if #self.inCollisionWithBagEntities > 0 then
        if self.inCollisionWithBagEntities[self.showBagIndex].alreadySetItems == false then
            -- self.groundBag:setItems(self.inCollisionWithBagEntities[self.showBagIndex].items)
            self.inCollisionWithBagEntities[self.showBagIndex].alreadySetItems = true
        end
    end


    local targetPosition = {
        x = 10,
        y = 0
    }
    -- if bagInterface.show then
    --     targetPosition.y = h - 77 - self.bag.rect.height - self.groundBag.rect.height
    -- else
    --     targetPosition.y = h - 77 - self.groundBag.rect.height
    -- end
    
    -- if self.bag.rect.y ~= h - 52 - self.bag.rect.height then
    --     self.bag:setPosition(10, h - 52 - self.bag.rect.height)
    -- end
    -- if self.groundBag.rect.y ~= targetPosition.y then 
    --     self.groundBag:setPosition(targetPosition.x, targetPosition.y)
    -- end

end


function Player:draw()
    Entity.draw(self);

    local w, h = love.window:getMode()
    local realCamX = 0
    local realCamY = 0
    -- Interface
    -- Quick Item Interface
    -- self:drawQuickSlots()
    -- Life
    local characterComponent = self.components["CharacterComponent"]
    local selfPosition = self.components["TransformComponent"].position
    local stats = characterComponent.stats

    -- BAG
    if bagInterface.show then
        -- Bag Icon
        -- self.bag:draw()
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

    love.graphics.print(#self.inCollisionWithBagEntities, 100, 100)
    if #self.inCollisionWithBagEntities > 0 then
        -- self.groundBag:draw()
    end
    -- self drawItemInMouse()
end

-- self.groundBag -> container gameobject used to show items 

local lshift = false
function Player:mousepressed(...)
    Entity.mousepressed(self, ...)
    -- self.groundBag:mousepressed(...)


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
    -- self.groundBag:mousereleased( ... )
    local mx, my, button = ...
    local w, h = love.window.getMode()
end

function Player:keypressed(key)
    Entity.keypressed(self, key)

    if key == "i" then
        self.autoFire = not self.autoFire
    end
    if key == "k" then
        local itemToLoot = love.math.random(1, #_G.dbObject.Equipments)
        self.inventory:addItemInFirstEmptySlot(_G.dbObject.Equipments[itemToLoot], 1)
    end
    if key == "j" then
        local newItem = _G.dbObject.createEquipementById("Parchment of Vitality")
        self.inventory:addItemInFirstEmptySlot(newItem, 1)
    end
end

function Player:keyreleased(key)
    Entity.keyreleased(self, key)
    if key  == "lshift" then lshift = false end
end

return Player
local GamePlayScreen = require(_G.libDir .. "middleclass")("GamePlayScreen", _G.xle.Scene)
local MouseUtil = require(_G.srcDir .. "utils.MouseUtil")

local GOManaBar = require(_G.srcDir .. "scenes.scene-play.gameobjects.go-mana_bar")
local GOExperienceBar = require(_G.srcDir .. "scenes.scene-play.gameobjects.go-experience_bar")
local GOHealthBar = require(_G.srcDir .. "scenes.scene-play.gameobjects.go-health_bar")
local GOStatsInterface = require(_G.srcDir .. "scenes.scene-play.gameobjects.go-stats_interface")
local GOButtonStatInterface = require(_G.srcDir .. "scenes.scene-play.gameobjects.go-button_stat_interface")
local GOQuickSlots = require(_G.srcDir .. "scenes.scene-play.gameobjects.go-quick_slots")
local GOInventory = require(_G.srcDir .. "scenes.scene-play.gameobjects.go-inventory")
local GOButtonInventory = require(_G.srcDir .. "scenes.scene-play.gameobjects.go-button_inventory")
local GOBlacksmithInterface = require(_G.srcDir .. "scenes.scene-play.gameobjects.go-blacksmith_interface")

function GamePlayScreen:initialize (name, active)
    _G.xle.Scene.initialize(self, name, active)
    self.enter_realm_sound = love.audio.newSource("src/assets/sfx/enter_realm.mp3", "static")


    -- GameObjects
    self.interface = {
        GOManaBar = GOManaBar:new(),
        GOExperienceBar = GOExperienceBar:new(),
        GOHealthBar = GOHealthBar:new(),
        GOStatsInterface = GOStatsInterface:new(),
        GOButtonStatInterface = GOButtonStatInterface:new(),
        GOQuickSlots = GOQuickSlots:new(),
        GOInventory = GOInventory:new(),
        GOButtonInventory = GOButtonInventory:new(),
        GOBlacksmithInterface = GOBlacksmithInterface:new()
    }

    self.showStatInterface = false
    self.showBagInterface = false
end

function GamePlayScreen:init()
    _G.xle.Scene.init(self)

    local realm = require(_G.srcDir .. "worlds.realm.realm"):new(self, true)
    local nexus = require(_G.srcDir .. "worlds.nexus.nexus"):new(self)
    local vault = require(_G.srcDir .. "worlds.vault.vault"):new(self)

    self.worlds = {
        realm,
        nexus,
        vault
    }

    self.enter_realm_sound.play(self.enter_realm_sound)

    self.showStatInterface = false
end

function GamePlayScreen:goToWorld(worldId)
    for k, v in pairs(self.worlds) do
        if v.isActive and v.world_name ~= worldId then
            v.isActive = false
        end
    end
    for k, v in pairs(self.worlds) do
        if not v.isActive and v.world_name == worldId then
            v.isActive = true
        end
    end
    self.enter_realm_sound:play()
end

function GamePlayScreen:update(...)
    for i, v in ipairs(self.worlds) do
        if v.isActive then
            if v.update ~= nil then
                v:update(...)
            end
        end
    end
end

function GamePlayScreen:draw(...)
    for i, v in ipairs(self.worlds) do
        if v.isActive then
            if v.draw ~= nil then
                v:draw(...)
            end
            local playerResult = v:getEntitiesByComponentName("PlayerComponent")
            if #playerResult > 0 then
                local characterComponent = playerResult[1]:getComponent("CharacterComponent")
                if characterComponent ~= nil then
                    self.interface.GOManaBar:draw(characterComponent.stats)
                    self.interface.GOExperienceBar:draw(characterComponent)
                    self.interface.GOHealthBar:draw(characterComponent)
                    self.interface.GOStatsInterface:draw(self.showStatInterface, characterComponent)
                    self.interface.GOButtonStatInterface:draw(self.showStatInterface)
                    self.interface.GOButtonInventory:draw(self.showBagInterface)
                end
                if playerResult[1].quickSlots ~= nil then
                    self.interface.GOQuickSlots:draw(playerResult[1].quickSlots)
                end
                if playerResult[1].inventory ~= nil then
                    if self.showBagInterface then 
                        self.interface.GOInventory:draw(playerResult[1].inventory)
                    end
                end
            end
            self.interface.GOBlacksmithInterface:draw(true)
            -- v:getSystem("WorldBossSystem"):drawOnScreen()
            MouseUtil.drawItem()
        end
    end

    
end

function GamePlayScreen:keyreleased(...)
    for i, v in ipairs(self.worlds) do
        if v.isActive then
            if v.keyreleased ~= nil then
                v:keyreleased(...)
            end
        end
    end

    local key = ...
    self.interface.GOButtonStatInterface:keyreleased(key)
    self.interface.GOStatsInterface:keyreleased(key)
    if key == "b" then
        if self.showBagInterface == false then
            self.showBagInterface = true
            self.showStatInterface = false
        else
            self.showBagInterface = false
        end
    end
    if key == "c" then
        if self.showStatInterface == false then
            self.showStatInterface = true
            self.showBagInterface = false
        else
            self.showStatInterface = false
        end
    end
end

function GamePlayScreen:keypressed(...)
    for i, v in ipairs(self.worlds) do
        if v.isActive then
            if v.keypressed ~= nil then
                v:keypressed(...)
            end
        end
    end
    local key = ...
    if key == "escape" then
        _G.xle.Screen.goToScreen("main_menu_screen");
    end
end

function GamePlayScreen:mousereleased(...)
    for i, v in ipairs(self.worlds) do
        if v.isActive then
            if v.mousereleased ~= nil then
                v:mousereleased(...)
            end
            local playerResult = v:getEntitiesByComponentName("PlayerComponent")
            if #playerResult > 0 then
                local characterComponent = playerResult[1]:getComponent("CharacterComponent")
                local mx, my, button = ...
                if characterComponent ~= nil then
                    if self.showStatInterface then
                        self.interface.GOStatsInterface:mousereleased(mx, my, button, characterComponent)
                    end
                end
                if playerResult[1].quickSlots ~= nil then
                    self.interface.GOQuickSlots:mousereleased(mx, my, button, playerResult[1].quickSlots, playerResult[1].inventory)
                end
                if playerResult[1].inventory ~= nil then
                    if self.showBagInterface then
                        self.interface.GOInventory:mousereleased(mx, my, button, playerResult[1].inventory)
                    end
                end
            end
            self.interface.GOBlacksmithInterface:mousereleased(...)
        end
    end
    
end

function GamePlayScreen:mousepressed(...)
    for i, v in ipairs(self.worlds) do
        if v.isActive then
            if v.mousepressed ~= nil then
                v:mousepressed(...)
            end
            local playerResult = v:getEntitiesByComponentName("PlayerComponent")
            if #playerResult > 0 then

                if playerResult[1].inventory ~= nil then
                    local mx, my, button = ...
                    if self.showBagInterface then
                        self.interface.GOInventory:mousepressed(mx, my, button, playerResult[1].inventory)
                    end
                    self.interface.GOQuickSlots:mousepressed(mx, my, button, playerResult[1].quickSlots)
                end
            end
            self.interface.GOBlacksmithInterface:mousepressed(...)
        end
    end

end

return GamePlayScreen;
local GamePlayScreen = require(_G.libDir .. "middleclass")("GamePlayScreen", _G.xle.Screen)

function GamePlayScreen:initialize (name, active)
    _G.xle.Screen.initialize(self, name, active)
    self.enter_realm_sound = love.audio.newSource("src/assets/sfx/enter_realm.mp3", "static")
end

function GamePlayScreen:init()
    _G.xle.Screen.init(self)

    local realm = require(_G.srcDir .. "worlds.realm.realm"):new(self, true)
    local nexus = require(_G.srcDir .. "worlds.nexus.nexus"):new(self)
    local vault = require(_G.srcDir .. "worlds.vault.vault"):new(self)

    self.worlds = {
        realm,
        nexus,
        vault
    }

    self.enter_realm_sound.play(self.enter_realm_sound)
end

function GamePlayScreen:goToWorld(worldId)
    for k, v in pairs(self.worlds) do
        if v.isActive and v.world_name ~= worldId then
            v.isActive = false
        end
    end
    print(v)
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
        end
    end
end

function GamePlayScreen:mousepressed(...)
    for i, v in ipairs(self.worlds) do
        if v.isActive then
            if v.mousepressed ~= nil then
                v:mousepressed(...)
            end
        end
    end
end

return GamePlayScreen;
local GamePlayScreen = require(_G.libDir .. "middleclass")("GamePlayScreen", _G.xle.Screen)

function GamePlayScreen:initialize (name, active)
    _G.xle.Screen.initialize(self, name, active)
    self.enter_realm_sound = love.audio.newSource("src/assets/sfx/enter_realm.mp3", "static")
end

function GamePlayScreen:init()
    _G.xle.Screen.init(self)

    local Realm = require(_G.srcDir .. "worlds.realm.realm"):new()

    self.nodes = {
        Realm,
    }

    self.enter_realm_sound.play(self.enter_realm_sound)
end


function GamePlayScreen:update(...)
    for i, v in ipairs(self.nodes) do
        if v.update ~= nil then
            v:update(...)
        end
    end
end

function GamePlayScreen:draw(...)
    for i, v in ipairs(self.nodes) do
        if v.draw ~= nil then
            v:draw(...)
        end
    end
end

function GamePlayScreen:keyreleased(...)
    for i, v in ipairs(self.nodes) do
        if v.keyreleased ~= nil then
            v:keyreleased(...)
        end
    end
end

function GamePlayScreen:keypressed(...)
    for i, v in ipairs(self.nodes) do
        if v.keypressed ~= nil then
            v:keypressed(...)
        end
    end
    local key = ...
    if key == "escape" then
        _G.xle.Screen.goToScreen("main_menu");
    end
end

function GamePlayScreen:mousereleased(...)
    for i, v in ipairs(self.nodes) do
        if v.mousereleased ~= nil then
            v:mousereleased(...)
        end
    end
end

function GamePlayScreen:mousepressed(...)
    for i, v in ipairs(self.nodes) do
        if v.mousepressed ~= nil then
            v:mousepressed(...)
        end
    end
end

return GamePlayScreen;
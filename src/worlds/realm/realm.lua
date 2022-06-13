
local World = require(_G.engineDir .. "world");
local Realm = require(_G.libDir .. "middleclass")("Realm", World);
local RealmData = require(_G.srcDir .. "worlds.realm.data")

-- Systems
local WorldBossSystem = require(_G.srcDir .. "systems.system-world_boss")
local CameraSystem = require(_G.srcDir .. "systems.system-camera")

function Realm:initialize (screen, active)
  World.initialize(self, screen, active or false, "realm", RealmData, 4);

  self:addSystem(WorldBossSystem:new(self))
  self:addSystem(CameraSystem:new(self))
end

return Realm

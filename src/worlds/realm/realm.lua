
local World = require(_G.engineDir .. "world");
local Realm = require(_G.libDir .. "middleclass")("Realm", World);
local RealmData = require(_G.srcDir .. "worlds.realm.data")

-- Systems
local WorldBossSystem = require(_G.srcDir .. "systems.system-world_boss")

function Realm:initialize (screen, active)
  World.initialize(self, screen, active or false, "realm", RealmData, 4);

  self:addSystem(WorldBossSystem:new(self))
end

return Realm

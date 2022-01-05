
local World = require(_G.engineDir .. "world");
local Realm = require(_G.libDir .. "middleclass")("Realm", World);
local RealmData = require(_G.srcDir .. "worlds.realm.data")

function Realm:initialize (screen, active)
  World.initialize(self, screen, active or false, "realm", RealmData, 4);
end

return Realm

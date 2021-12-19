
local World = require(_G.engineDir .. "world");
local Realm = require(_G.libDir .. "middleclass")("Realm", World);
local RealmData = require(_G.srcDir .. "worlds.Realm.data")

function Realm:initialize ()
  World.initialize(self, "realm", RealmData);
end

return Realm

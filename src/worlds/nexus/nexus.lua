
local World = require(_G.engineDir .. "world");
local Nexus = require(_G.libDir .. "middleclass")("Nexus", World);
local NexusData = require(_G.srcDir .. "worlds.nexus.data")

function Nexus:initialize ()
  World.initialize(self, "nexus", NexusData);
end

return Nexus

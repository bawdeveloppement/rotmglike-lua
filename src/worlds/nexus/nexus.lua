
local World = require(_G.engineDir .. "world");
local Nexus = require(_G.libDir .. "middleclass")("Nexus", World);
local NexusData = require(_G.srcDir .. "worlds.nexus.data")

function Nexus:initialize (screen, active)
  World.initialize(self, screen, active or false, "nexus", NexusData);
end

return Nexus

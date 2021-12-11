-- Map.tsx
    -- Tiles
    -- Fontaine life / mana
    -- Entity Shop

local World = require(_G.engineDir .. "world");
local Nexus = require(_G.libDir .. "middleclass")("Nexus", World);

function Nexus:initialize ()
    World.initialize(self, "nexus");
end

return Nexus
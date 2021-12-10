-- Map.tsx
    -- Tiles
    -- Fontaine life / mana
    -- Entity Shop

local World = require(_G.engineDir .. "world");
local Nexus = require(_G.libDir .. "middleclass")("Nexus", World);

local WorldData = {
    { 1, 0, 2, 0, 1, 1, 1 },
    { 1, 0, 2, 0, 1, 1, 1 },
    { 1, 0, 2, 0, 1, 1, 1 },
    { 1, 0, 2, 0, 1, 0, 2 },
}

function Nexus:initialize()
    World.initialize(self);
end

return Nexus

local System = require(_G.libDir .. "middleclass")("System");

function System:initialize(world)
    self.world = world 
end

return System
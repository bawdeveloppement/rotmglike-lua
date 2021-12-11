local World = require(_G.libDir .. "middleclass")("World");

function World:initialize( name )
    self.entities = {}
end

function World:update()
end

function World:draw()
    
end

return World
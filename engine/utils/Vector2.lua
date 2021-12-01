local Vector2 = require(_G.engineDir .. "middleclass")("Vector2");

function Vector2:initialize(x, y)
    self.x, self.y = x or 0, y or 0
end

function Vector2:set(x, y)
    self.x, self.y = x or 0, y or 0
end

function Vector2:add(x, y)
    self:set(self.x + (x or 0), self.y + (y or 0))
end

Vector2.static.UP = function (y)
    return Vector2:new( 0, y );
end

Vector2.static.LEFT = function (x)
    return Vector2:new( x, 0 );
end

return Vector2;
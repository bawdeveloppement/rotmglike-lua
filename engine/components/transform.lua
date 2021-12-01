local Component = require("component")
local Transform = require("engine.middleclass")("Transform", Component)

function Transform:initialize( data )
    self.initialize(
        "Transform",
        data
    );
end

function Transform:update ()
end

function Transform:draw () 
end

return Transform
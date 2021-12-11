local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "MonsterAI" and inherit of Component
local MonsterAIComponent = Class("MonsterAIComponent", Component);

MonsterAIComponent.static.name = "MonsterAIComponent"

function MonsterAIComponent:initialize( parent )
    Component.initialize(self, parent)
    self.name = "MonsterAIComponent";
end


function MonsterAIComponent:update()
end

return MonsterAIComponent
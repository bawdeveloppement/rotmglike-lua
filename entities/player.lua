-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")

local MoveComponent = require(_G.baseDir.."components.move")
local CharacterComponent = require(_G.baseDir.."components.character")

local Player = require(_G.engineDir .. "middleclass")("Player", Entity)

return Entity:new(
    "Player",
    {
        { class = TransformComponent },
        { class = MoveComponent  },
        { class = CharacterComponent}
    }
)
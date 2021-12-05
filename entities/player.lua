-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")
local SpriteComponent = require(_G.engineDir.."components.sprite")

local MoveComponent = require(_G.baseDir.."components.move")
local CharacterComponent = require(_G.baseDir.."components.character")

local Player = require(_G.engineDir .. "middleclass")("Player", Entity)

return Entity:new(
    "Player",
    {
        { class = TransformComponent, data = { position = { x = 50, y = 60 }} },
        { class = MoveComponent },
        { class = CharacterComponent },
        { class = SpriteComponent, data = { imageUri = "assets/textures/hp.png"} }
    }
)
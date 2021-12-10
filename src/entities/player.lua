-- Components
local Entity = require(_G.engineDir .. "entity")
local TransformComponent = require(_G.engineDir.."components.transform")
local SpriteComponent = require(_G.engineDir.."components.sprite")

local MoveComponent = require(_G.srcDir.."components.move")
local CharacterComponent = require(_G.srcDir.."components.character")

local Player = require(_G.libDir .. "middleclass")("Player", Entity)

function Player:initialize()
    Entity.initialize( self, "Player", {
        { class = TransformComponent, data = { position = { x = 50, y = 60 }} },
        { class = MoveComponent },
        { class = CharacterComponent },
        { class = SpriteComponent, data = { size={ w = 16, h=16}, imageUri = "src/assets/textures/rotmg/EmbeddedAssets_playersSkins16Embed_.png"} }
    });
end

return Player
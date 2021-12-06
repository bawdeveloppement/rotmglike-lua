local Entity = require(_G.engineDir .. "entity")
local Transform = require(_G.engineDir .. "components.transform")
local Sprite = require(_G.engineDir .. "components.sprite")
local Projectile = require(_G.libDir .. "middleclass")("Projectile", Entity);

function Projectile:initialize()
    Entity.initialize(self, "Projectile", {
        { class = Transform },
        { class = Sprite, data = { width = 32, height = 32 }}
    });
end

return Projectile
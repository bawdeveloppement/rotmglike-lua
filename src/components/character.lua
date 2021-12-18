local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CharacterComponent = Class("CharacterComponent", Component);

function CharacterComponent:initialize( parent )
    Component.initialize(self, parent)
    
    self.level = 1
    self.exp = 0
    self.maxExp = 100

    self.stats = {
        life = 100,
        mana = 100,
        max_life = 100,
        max_mana = 100,
        attack = 1,
        wisdom = 1,
        force = 1,
        dexterity = 1,
        speed = 1,
        defense = 1
    }

    self.statPoints = 10

    self.skin = {
        texture = "",
    }

    self.audio = {
        hit = love.audio.newSource("src/assets/sfx/player/archer_hit.mp3", "static"),
        death = love.audio.newSource("src/assets/sfx/player/archer_death.mp3", "static")
    }
end

function CharacterComponent:getDamage( damage )
    self.stats.life = self.stats.life - damage
    self.audio.hit.play(self.audio.hit);
end

return CharacterComponent
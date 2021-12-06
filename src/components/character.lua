local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CharacterComponent = Class("Character", Component);

CharacterComponent.static.name = "Character"

function CharacterComponent:initialize( parent )
    Component.initialize(self, parent)
    self.name = "Character"
    
    self.level = 1
    self.exp = 0
    self.maxExp = 100

    self.stats = {
        max_life = 100,
        max_mana = 100,
        attack = 1,
        wisdom = 1,
        force = 1,
        dexterity = 1,
        speed = 1,
        defense = 1
    }

    self.statPoint = 10

    self.life = 100
    self.mana = 100
end

function CharacterComponent:update()
end

return CharacterComponent
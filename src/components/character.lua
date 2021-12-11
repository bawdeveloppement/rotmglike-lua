local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CharacterComponent = Class("Character", Component);

CharacterComponent.static.name = "Character"

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
end

local lshift = true
function CharacterComponent:keypressed(key)
   if key == "lshift" then lshift = true end
    if key == "b" then
        if bagInterface.show == false then
            bagInterface.show = true
            charInterface.show = false
        else
            bagInterface.show = false
        end
    end
    if key == "c" then
        if charInterface.show then
            charInterface.show = false
        else
            charInterface.show = true
            bagInterface.show = false
        end
    end
    for i, v in ipairs(quickSlots) do
        if v.key ~= nil then
            if key == v.key then
                if v.item ~= nil then
                    if v.item.use ~= nil then
                        if v.item.use.destroy == true then
                            print(quickSlots[i].quantity )
                            quickSlots[i].quantity = quickSlots[i].quantity - 1
                            print(quickSlots[i].quantity )
                        end
                        v.item.use.handler()
                    end
                end
            end
        end
    end
end

return CharacterComponent
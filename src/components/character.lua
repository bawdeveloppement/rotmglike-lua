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
        level_up = love.audio.newSource("src/assets/sfx/level_up.mp3", "static"),
        hit = love.audio.newSource("src/assets/sfx/player/archer_hit.mp3", "static"),
        death = love.audio.newSource("src/assets/sfx/player/archer_death.mp3", "static")
    }

    self.attacksLog = {}

    self.buttonSound = love.audio.newSource("src/assets/sfx/button_click.mp3", "static");

    -- events listeners
    self.onDeath = {}

    local enemyList = {
        "player"
    }
end

function CharacterComponent:isEnemyOf( entity )
    return false
end

local mx, my = 0, 0;
function CharacterComponent:update()
    mx, my = love.mouse.getPosition()
    
    local restExp = self.exp - self.maxExp
    if restExp >= 0 then
        self.exp = restExp
        self.level = self.level + 1;
        self.stats.life = self.stats.max_life;
        self.statPoints = self.statPoints + 1;
        self.audio.level_up.play(self.audio.level_up)
    end

    if self.stats.life <= 0 then
        for _, v in ipairs(self.onDeath) do if type(v) == "function" then v() end end
        self.entity.markDestroy = true
    end
end


function CharacterComponent:addOnDeath( fnName, func )
    
end

function CharacterComponent:getDamage( damage, enemyId )
    self.stats.life = self.stats.life - damage
    table.insert(self.attacksLog, #self.attacksLog + 1, { name = enemyId or "unknown", damage = damage })
    print(self.attacksLog[#self.attacksLog].name .. " attack " .. self.entity.id .. " -" .. self.attacksLog[#self.attacksLog].damage)
    self.audio.hit.play(self.audio.hit);
end

function CharacterComponent:draw()
end

return CharacterComponent
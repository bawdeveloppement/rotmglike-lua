local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CharacterComponent = Class("CharacterComponent", Component);

CharacterComponent.static.name = "CharacterComponent"

CharacterComponent.static.statOffToHere = {
    ["0"]  = "max_life",
    ["3"]  = "max_mana",
    ["21"] = "defense",
    ["22"] = "speed",
    ["20"] = "attack",
    ["26"] = "vitality",
    ["27"] = "wisdom",
    ["28"] = "dexterity"
}

function CharacterComponent:initialize( parent, data )
    Component.initialize(self, parent)

    self.level = 1
    self.exp = 0
    self.max_exp = 100

    self.stats = {
        life = 100,
        mana = 100,
        max_life = {
            base = 100,
            equipment = 0,
        },
        max_mana = {
            base = 100,
            equipment = 0,
        },
        attack = {
            base = 1,
            equipment = 0,
        },
        wisdom = {
            base = 1,
            equipment = 0,
        },
        dexterity = {
            base = 1,
            equipment = 0,
        },
        speed = {
            base = 1,
            equipment = 0,
        },
        defense = {
            base = 1,
            equipment = 0,
        },
        vitality = {
            base = 1,
            equipment = 0,
        }
    }

    self.statPoints = 10

    self.class = "archer"

    self.skin = {
        texture = "",
    }

    local soundPath = ""
    
    if data.isPlayer == true then
        soundPath = "player/"..self.class
        self.audio = {
            hit = _G.xle.ResourcesManager:getOrAddSound(soundPath.."_hit.mp3"),
            death = _G.xle.ResourcesManager:getOrAddSound(soundPath.."_death.mp3")
        }
    else
        self.audio = {
            hit = _G.xle.ResourcesManager:getOrAddSound(data.HitSound..".mp3"),
            death = _G.xle.ResourcesManager:getOrAddSound(data.DeathSound..".mp3")
        }
    end
    

    self.attacksLog = {}

    self.buttonSound = _G.xle.ResourcesManager:getOrAddSound("button_click.mp3");

    -- events listeners
    self.onDeath = {}
    self.onLevelUp = {}

    self.friendList = {
        self.entity.name
    }

    self.isPlayer = data.isPlayer or false
end

function CharacterComponent:isFriendOfById( entityId )
    local found = false
    for i, v in ipairs(self.friendList) do
        if v == self.world:getEntityById(entityId).name then
            found = true
        end
    end
    return found
end

function CharacterComponent:isFriendOfByName( entityName )
    local found = false
    for i, v in ipairs(self.friendList) do
        if v == entityName then
            found = true
        end
    end
    return found
end

local mx, my = 0, 0;
function CharacterComponent:update(...)
    mx, my = love.mouse.getPosition()

    local restExp = self.exp - self.max_exp
    if restExp >= 0 then
        self.exp = restExp
        self.level = self.level + 1;
        self.max_exp = self.max_exp * 2
        self.stats.life = self.stats.max_life.base + self.stats.max_life.equipment;
        self.statPoints = self.statPoints + 1;
        for _, v in pairs(self.onLevelUp) do
            v.func(self)
        end
    end

    if self.stats.life <= 0 then
        for k, v in pairs(self.onDeath) do
            v.func(self)
        end
        self.entity.markDestroy = true
    end

    if self.stats.life < self.stats.max_life.base + self.stats.max_life.equipment then
        self.stats.life = self.stats.life + (self.stats.vitality.base + self.stats.vitality.equipment / 300)
    end


    if self.isPlayer then
        local newStats = {
            ["max_life"] = 0,
            ["max_mana"] = 0,
            ["defense"] = 0,
            ["speed"] = 0,
            ["attack"] = 0,
            ["vitality"] = 0,
            ["wisdom"] = 0,
            ["dexterity"] = 0
        }
        for i, v in ipairs(self.entity.quickSlots) do
            if i > 3 and i < 8 then
                if v.item ~= nil then
                    if v.item.ActivateOnEquip ~= nil then
                        if v.item.ActivateOnEquip.IncrementStat ~= nil then
                            for k, v in pairs (v.item.ActivateOnEquip.IncrementStat) do
                                local currentStatName = CharacterComponent.statOffToHere[k]
                                newStats[currentStatName] = newStats[currentStatName] + v
                            end
                        end
                    end
                end
            end
        end
        for k, v in pairs(newStats) do
            self.stats[k].equipment = v
        end
    end
end


function CharacterComponent:addOnDeath( fnName, func )
    local found = nil
    for i, v in ipairs(self.onDeath) do
        if v.name == fnName then
            found = v
        end
    end
    if found == nil then
        table.insert(self.onDeath, #self.onDeath + 1, { name = fnName, func = func } )
    end
end

function CharacterComponent:addOnLevelUp( fnName, func )
    local found = nil
    for i, v in ipairs(self.onLevelUp) do
        if v.name == fnName then
            found = v
        end
    end
    if found == nil then
        table.insert(self.onLevelUp, #self.onLevelUp + 1, { name = fnName, func = func } )
    end
end

function CharacterComponent:getExp ( xp )
    self.exp = self.exp + xp
end

function CharacterComponent:getDamage( damage, enemyId )
    self.stats.life = self.stats.life - damage
    table.insert(self.attacksLog, #self.attacksLog + 1, { name = enemyId or "unknown", damage = damage })
    if self.audio.hit:isPlaying() then
        self.audio.hit:stop();
        self.audio.hit:play();
    else
        self.audio.hit:play();
    end
    -- print(self.attacksLog[#self.attacksLog].name .. " attack " .. self.entity.id .. " -" .. self.attacksLog[#self.attacksLog].damage)
end


return CharacterComponent
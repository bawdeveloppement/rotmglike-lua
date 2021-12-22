local Component = require(_G.engineDir .. "component")
local Class = require(_G.libDir .. "middleclass")

-- Create a class called "CharacterComponent" and inherit of Component
local CharacterComponent = Class("CharacterComponent", Component);

CharacterComponent.static.statOffToHere = {
    ["21"] = "Defense",
    ["22"] = "Speed",
    ["20"] = "Attack",
    ["26"] = "Vitality",
    ["27"] = "Wisdom",
    ["28"] = "Dexterity"
}

function CharacterComponent:initialize( parent, data )
    Component.initialize(self, parent)

    self.level = 1
    self.exp = 0
    self.max_exp = 100

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
        defense = 1,
        vitality = 1
    }

    self.statPoints = 10

    self.class = "archer"

    self.skin = {
        texture = "",
    }

    local soundPath = ""
    
    if data.isPlayer == true then
        soundPath = "player/"..self.class
    else
        soundPath = "monster/"..self.entity.name.."s"
    end
    
    self.audio = {
        hit = _G.xle.ResourcesManager:getOrAddSound(soundPath.."_hit.mp3"),
        death = _G.xle.ResourcesManager:getOrAddSound(soundPath.."_death.mp3")
    }

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
        self.stats.life = self.stats.max_life;
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

    if self.stats.life < self.stats.max_life then
        self.stats.life = self.stats.life + self.stats.vitality / 10 
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
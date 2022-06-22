_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.libDir    = _G.baseDir .. "lib."
_G.engineDir    = _G.libDir .. "engine."
_G.srcDir    = _G.baseDir .. "src."

love.graphics.setDefaultFilter("nearest")

local scenes = require(_G.srcDir .. "scenes.scenes")

local loveVersion = 11.3

love.audio.setVolume(0.1)

_G.font = love.graphics.newFont("src/assets/fonts/yoster.ttf")
_G.font1 = love.graphics.newFont("src/assets/fonts/super-legend-boy-font/SuperLegendBoy-4w8Y.ttf")
_G.font2 = love.graphics.newFont("src/assets/fonts/a-goblin-appears-font/AGoblinAppears-o2aV.ttf")
_G.font3 = love.graphics.newFont("src/assets/fonts/eight-bit-dragon-font/EightBitDragon-anqx.ttf")
_G.font4 = love.graphics.newFont("src/assets/fonts/rubber-biscuit/RUBBBRO_.TTF")

_G.xle = require(_G.engineDir .. "xle")

_G.string.split = function (self, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

_G.isDebug = false

local JSON = require("lib.json")

-- local ok, err = love.filesystem.read("src/assets/prefabs/dat1.json")
-- local dat = JSON:decode(ok).Object

local container, containerErr = love.filesystem.read("src/assets/prefabs/Container.json")
local containerData = JSON:decode(container)

local equipment, equipementErr = love.filesystem.read("src/assets/prefabs/Equipment.json")
local equipmentData = JSON:decode(equipment)

local projectiles, projectilesErr = love.filesystem.read("src/assets/prefabs/Projectile.json")
local projectilesData = JSON:decode(projectiles)

local characters, charactersErr = love.filesystem.read("src/assets/prefabs/Character.json")
local charactersData = JSON:decode(characters)

local loadedTextures = {}
local validData = {}

_G.pack = function (...)
    return { ... }, select("#", ...)
end

_G.dbObject = {
    Containers = containerData,
    Equipments = equipmentData,
    Projectiles = projectilesData,
    Characters = charactersData,
    
}
_G.dbObject.getCharacter = function (characterId)
    local toReturn = nil;
    print(characterId .. "dzadzad")
    for k, v in ipairs(_G.dbObject.Characters) do
        if v.id == characterId then
            toReturn = v;
        end
    end
    return toReturn
end

_G.dbObject.createEquipementById = function (equipementId)
    local toReturn = nil;
    for k, v in ipairs(_G.dbObject.Equipments) do
        if v.id == equipementId then
            toReturn = v;
        end
    end
    return toReturn
end

for index, value in ipairs(require(_G.srcDir .. "assets.textures.textures")) do
    --#region LOADING TEXTURES / items
    local indexName = value:split(".")[1]
    _G.xle.ResourcesManager:addTexture(indexName, "src/assets/textures/"..value)
end

_G.errorAudio = _G.xle.ResourcesManager:getOrAddSound("error.mp3")

_G.xleInstance = _G.xle.Init:new("astral_kingdom", scenes)

local foofoo = "d"

function test(foo)
    foo = "dzadzad"
end

_G.camera = require(_G.libDir .. "camera")()


_G.itemInMouse = {
    item = nil,
    quantity = 0,
    lastIndex = nil
}
_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.libDir    = _G.baseDir .. "lib."
_G.engineDir    = _G.libDir .. "engine."
_G.srcDir    = _G.baseDir .. "src."

love.graphics.setDefaultFilter("nearest")

local screens = {
    { name = "main_menu_screen", buildIndex = 1 },
    { name = "option", buildIndex = 2 },
    { name = "play", buildIndex = 3 },
}

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

_G.isDebug = true

local JSON = require("lib.json")

-- local ok, err = love.filesystem.read("src/assets/prefabs/dat1.json")
-- local dat = JSON:decode(ok).Object

local container, containerErr = love.filesystem.read("src/assets/prefabs/Container.json")
local containerData = JSON:decode(container)

local equipment, equipementErr = love.filesystem.read("src/assets/prefabs/Equipment.json")
local equipmentData = JSON:decode(equipment)

local projectiles, projectilesErr = love.filesystem.read("src/assets/prefabs/Projectile.json")
local projectilesData = JSON:decode(projectiles)

local loadedTextures = {}
local validData = {}

_G.pack = function (...)
    return { ... }, select("#", ...)
end

_G.dbObject = {
    Containers = containerData,
    Equipments = equipmentData,
    Projectiles = projectilesData
}

for index, value in ipairs(require(_G.srcDir .. "assets.textures.textures")) do
    --#region LOADING TEXTURES / items
    local indexName = value:split(".")[1]
    _G.xle.ResourcesManager:addTexture(indexName, "src/assets/textures/"..value)
end

_G.errorAudio = _G.xle.ResourcesManager:getOrAddSound("error.mp3")

_G.xleInstance = _G.xle.Init:new("astral_kingdom", screens)
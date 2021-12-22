_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.libDir    = _G.baseDir .. "lib."
_G.engineDir    = _G.libDir .. "engine."
_G.srcDir    = _G.baseDir .. "src."

love.graphics.setDefaultFilter("nearest")

local screens = {
    { name = "main_menu", buildIndex = 1 },
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


local JSON = require("lib.json")

local ok, err = love.filesystem.read("src/assets/prefabs/dat1.json")
local dat = JSON:decode(ok).Object
local loadedTextures = {}
local validData = {}

_G.pack = function (...)
    return { ... }, select("#", ...)
end

_G.dbObject = {
    Containers = {},
    Equipments = {}
}


for index, value in ipairs(dat) do
    --#region LOADING TEXTURES / items
    for key, v in pairs(value) do
        -- Load textures
        if key == "Texture" then
            if _G.xle.ResourcesManager:getTexture(v.File) == nil and v.File ~= "invisible" and v.File ~= "lofiChar8x8" and v.File ~= "lofiChar216x8" and v.File ~= "lofiChar216x16"  and v.File ~= "lofiChar16x16"  and v.File ~= "lofiChar16x8"  and v.File ~= "lofiChar28x8"  and v.File ~= "d1lofiObjBig" then
                validData[#validData + 1] = dat[index]
                if string.find(v.File, "Embed") then
                    _G.xle.ResourcesManager:addTexture(v.File, "src/assets/textures/rotmg/EmbeddedAssets_" .. v.File .. "_.png")
                else
                    _G.xle.ResourcesManager:addTexture(v.File, "src/assets/textures/rotmg/EmbeddedAssets_" .. v.File .. "Embed_.png")
                end
            end
        end
        if key == "Class" and value[key] == "Container" then
            table.insert(_G.dbObject.Containers, value)
        end

        if key == "Class" and value[key] == "Equipment" then
            table.insert(_G.dbObject.Equipments, value)
        end
    end
    --#endregion
end

_G.xleInstance = _G.xle.Init:new(screens)
_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.libDir    = _G.baseDir .. "lib."
_G.engineDir    = _G.libDir .. "engine."
_G.srcDir    = _G.baseDir .. "src."

love.graphics.setDefaultFilter("nearest")

local world = {
    entities = {
        require("src.entities.bag"),
        require("src.entities.player"):new(),
        require("src.entities.monster"):new({
            position = { x = 50, y = 50 }
        }),
        require("src.entities.monster_spawner"):new()
    }
}

function love.update (dt)
    for i, v in ipairs(world.entities) do
        v:update()
    end
end

function love.draw ()
    for i, v in ipairs(world.entities) do
        v:draw()
    end
end
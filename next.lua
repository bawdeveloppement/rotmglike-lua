_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.engineDir    = _G.baseDir .. "engine."

local world = {
    entities = {
        require("entities.bag"),
        require("entities.player"),
        require("entities.bat"),
        require("entities.monster_spawner")
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
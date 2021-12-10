local God = require(_G.libDir .. "middleclass")("God")
local Screen = require(_G.engineDir .. "screen")

function God:initialize()
    for _, v in ipairs(_G.callbacks.supported) do
        love[v] = function (...)
            for _, screen in pairs(Screen.screensInstances) do
                -- print(screen:include("update"))
                if screen[v] ~= nil and type(screen[v]) == "function" and screen.active then
                    screen[v](screen, ...)
                end
            end
        end
    end
end

return God
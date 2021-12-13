return function ()
    local uuid = ""
    for i = 1, 16, 1 do
        if i % 4 == 0 then uuid = uuid .. "-" end
        uuid = uuid .. love.math.random(0, 9)
    end
    return uuid
end
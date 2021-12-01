_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.engineDir      = _G.baseDir .. "engine."

love.graphics.setDefaultFilter("nearest")


local player = {
    x = 0,
    y = 0,
    w = 32,
    h = 64,
    mana = 100,
    speed = 5,
    level = 1,
    exp = 0,
    maxExp = 100,
    life = 100,
    statPoints = 10,
    spell = {
        current = "",
        cooldown = 20
    },
    stats = {
        max_life = 100,
        max_mana = 100,
        attack = 1,
        wisdom = 1,
        force = 1,
        dexterity = 1,
        speed = 1,
        defense = 1
    },
    attack = {
        cooldown = 20,
        damage = 10
    },
    bag = {},
}

local bagInterface = {
    show = false
}

local charInterface = {
    show = false
}

local items = {
    { name = "sword_1", rarity = 4, texture = nil },
    { name = "sword_2", rarity = 4, texture = nil },
    { name = "sword_3", rarity = 4, texture = nil },
    { name = "sword_4", rarity = 3, texture = nil },
    { name = "sword_5", rarity = 4, texture = nil },
    { name = "sword_6", rarity = 4, texture = nil },
    { name = "sword_7", rarity = 2, texture = nil },
    { name = "sword_8", rarity = 1, texture = nil },
    { name = "health_potion", rarity = 0, texture = love.graphics.newImage("textures/hp.png")},
    { name = "mana_potion", rarity = 0, texture = love.graphics.newImage("textures/mp.png")}
}

local bags = {};

local bagTypes = {
    ["5"] = {
        name = "white",
        texture = "",
        color = { 255, 255, 255, 255},
    },
    ["4"] = {
        name = "purple",
        texture = "",
        color = { 133, 0, 133, 255},
    },
    ["3"] = {
        name = "yellow",
        texture = "",
        color = { 255, 255, 0, 255},
    },
    ["2"] = {
        name = "pink",
        texture = "",
        color = { 255, 192, 203, 255},
    },
    ["1"] = {
        name = "blue",
        texture = "",
        color = { 133, 0, 133, 255},
    },
    ["0"] = {
        name = "marroon",
        texture = "",
        color = { 165, 42, 42, 255},
    }
}

function pack(...)
    return { ... }, select("#", ...)
end

function dropBag (x, y, loots)
    local newBag = {
        x = x,
        y = y,
        loots = {},
        name = "marroon",
        texture = "",
        color = { 165, 42, 42, 255},
        rarity = 0
    }
    -- Up rarity depend on items in loots
    for k, lootName in pairs(loots) do
        for itemIndex, itemValue in ipairs(items) do
            if itemValue.name == lootName then
                newBag.loots[#newBag.loots + 1] = itemValue
                if itemValue.rarity > newBag.rarity then
                    newBag.rarity = itemValue.rarity 
                end
            end
        end
    end

    newBag.name = bagTypes[newBag.rarity..""].name
    newBag.texture = bagTypes[newBag.rarity..""].texture
    newBag.color = bagTypes[newBag.rarity..""].color

    table.insert(bags, #bags + 1, newBag)
end

local monsters = {}
local projectiles = {}

local levelUpSound = love.audio.newSource("sfx/level_up.mp3", "static")
local windowWidth, windowHeight, t = love.window.getMode(); 
function love.load ( config )
    config.title = "RPG"
end

local monstersTemplate = {
    {
        name = "bats",
        damage = 50,
        reward = {
            exp = love.math.random(0, 20),
            loots = { "health_potion", "mana_potion" }
        },
    },
    {
        name = "beholder",
        damage = 50,
        reward = {
            exp = love.math.random(0, 20),
            loots = { "health_potion", "mana_potion" }
        },
    },
    {
        name = "cyclops",
        damage = 50,
        reward = {
            exp = love.math.random(0, 20),
            loots = { "health_potion", "mana_potion" }
        },
    }
}

function createMonster( monsterTemplate , x, y)
    local rx = love.math.random(0, 800)
    return {
        x = x or rx,
        y = y or love.math.random(0, 600),
        w = 32,
        h = 32,
        life = 100,
        isInCollision = false,
        velocity = {
            x = 0,
            y = 0
        },
        reward = monsterTemplate.reward,
        sfx = {
            deathSound = love.audio.newSource("sfx/monster/".. monsterTemplate.name .."_death.mp3", "static"),
            hitSound = love.audio.newSource("sfx/monster/".. monsterTemplate.name .."_hit.mp3", "static")
        },
        attack = {
            cooldown = 50,
            damage = monsterTemplate.damage or 5
        },
        dexterity = 4,
    }
end

local spawnMonsterTimer = 100;
function monstersUpdate()
    if #monsters < 5 then
        if spawnMonsterTimer < 1 then
            table.insert(monsters, #monsters + 1, createMonster(monstersTemplate[love.math.random(1, #monstersTemplate)]))
            spawnMonsterTimer = 100
        else
            spawnMonsterTimer = spawnMonsterTimer - 1
        end
    end
    for i, v in ipairs(monsters) do
        local velx = math.cos(math.atan2(monsters[i].y - player.y, monsters[i].x - player.x))
        local vely = math.sin(math.atan2(monsters[i].y - player.y, monsters[i].x - player.x));
        -- body
        monsters[i].velocity.x = velx
        monsters[i].velocity.y = vely
        if monsters[i].isInCollision == false then 
            monsters[i].x = monsters[i].x - monsters[i].velocity.x * 1
            monsters[i].y = monsters[i].y - monsters[i].velocity.y * 1
        end
    end
    for i, v in ipairs(monsters) do
        monsters[i].attack.cooldown = monsters[i].attack.cooldown - 1;
        if monsters[i].x + monsters[i].w >= player.x and monsters[i].x <= player.x + player.w
        and monsters[i].y + monsters[i].h >= player.y and monsters[i].y <= player.y + player.h
        then
            monsters[i].isInCollision = true
            if monsters[i].attack.cooldown <= 0 then
                if player.life > 0 then
                    player.life = player.life - monsters[i].attack.damage;
                end
                monsters[i].attack.cooldown = 100
            end
        else
            monsters[i].isInCollision = false
        end
    end
end

function createProjectiles ( sx, sy, dx, dy, damage )
    return {
        x = sx,
        y = sy,
        w = 4,
        h = 4,
        start = {
            x = sx,
            y = sy
        },
        dest = {
            x = dx,
            y = dy
        },
        distance = 500,
        damage = damage or player.attack.damage,
        velocity = {
            x = math.cos(math.atan2(dy - sy, dx - sx)),
            y = math.sin(math.atan2(dy - sy, dx - sx))
        }
    }
end

function playerUpdate ()
    local z = love.keyboard.isDown("z");
    local q = love.keyboard.isDown("q");
    local d = love.keyboard.isDown("d");
    local s = love.keyboard.isDown("s");
    if z then
        player.y = player.y - (player.speed + player.stats.speed * 0.1);
    end

    if q then
        player.x = player.x - (player.speed + player.stats.speed * 0.1);
    end

    if d then
        player.x = player.x + (player.speed + player.stats.speed * 0.1);
    end

    if s then
        player.y = player.y + (player.speed + player.stats.speed * 0.1);
    end


    -- Level up
    local restExp = player.exp - player.maxExp
    if restExp >= 0 then
        player.exp = restExp 
        player.level = player.level + 1;
        player.life = player.stats.max_life;
        player.statPoints = player.statPoints + 1;
        levelUpSound.play(levelUpSound)
    end
end

local dps = 0

function projectilesUpdate ()
    local mouseIsDown = love.mouse.isDown(1);
    local mx, my = love.mouse.getPosition();
    if player.attack.cooldown <= 0 and ( mouseIsDown or autoAttack) then
        table.insert(projectiles, #projectiles + 1, createProjectiles(player.x, player.y, mx, my, 50))
        player.attack.cooldown = 20 - player.stats.dexterity * 0.5
    end
    if player.attack.cooldown > 0 then
        player.attack.cooldown = player.attack.cooldown - 1;
    end
    -- Move projectiles by velocity
    for i, v in ipairs(projectiles) do
        projectiles[i].x = projectiles[i].x + projectiles[i].velocity.x * 10
        projectiles[i].y = projectiles[i].y + projectiles[i].velocity.y * 10
    end
    -- Remove bullet in contact
    for mi, v in ipairs(monsters) do
        for bi, v in ipairs(projectiles) do
            if monsters[mi].x + monsters[mi].w >= projectiles[bi].x and monsters[mi].x <= projectiles[bi].x + projectiles[bi].w
            and monsters[mi].y + monsters[mi].h >= projectiles[bi].y and monsters[mi].y <= projectiles[bi].y + projectiles[bi].h
            then
                monsters[mi].life = monsters[mi].life - projectiles[bi].damage;
                dps = dps + projectiles[bi].damage;
                monsters[mi].sfx.hitSound.play(monsters[mi].sfx.hitSound);
                table.remove(projectiles, bi);
                if monsters[mi].life <= 0 then
                    monsters[mi].sfx.deathSound.play(monsters[mi].sfx.deathSound);
                    player.exp = player.exp + monsters[mi].reward.exp
                    dropBag(monsters[mi].x, monsters[mi].y, monsters[mi].reward.loots)
                    table.remove(monsters, mi)
                end
            end
        end
    end

    -- Remove projectiles after distance
    for i, proj in pairs(projectiles) do
        local longAB = function ( field ) return (proj[field] - proj.start[field]) * (proj[field] - proj.start[field]) end
        local longueur = math.sqrt(longAB("x") + longAB("y"))
        -- TODO: Projectiles distance
        if longueur > proj.distance then
            table.remove(projectiles, i);
        end
    end
end

local plus = {
    { x = 25, y = 345, name = "max_life" },
    { x = 25, y = 365, name = "max_mana" },
    { x = 25, y = 385, name = "attack" },
    { x = 25, y = 405, name = "defense" },
    { x = 25, y = 425, name = "wisdom" },
    { x = 25, y = 445, name = "dexterity" },
    { x = 25, y = 465, name = "speed" },
    { x = 25, y = 485, name = "force" },
}


local dpsTimer = 1
local maxDps = 0
local mx, my = 0, 0
function love.update ( dt )
    mx, my = love.mouse.getPosition()
    playerUpdate();
    projectilesUpdate();
    monstersUpdate();
    
    -- Reset DPS : 
    dpsTimer = dpsTimer - dt
    if dpsTimer <= 0 then
        dps = 0
        local leftover = math.abs(dpsTimer)
        dpsTimer = 1 - leftover
    end

    -- Get Max DPS :
    if dps > maxDps then maxDps = dps end
end


function drawPlus ( index )
    love.graphics.rectangle("line", plus[index].x - 8, plus[index].y - 8, 16, 16)
    if player.statPoints > 0 then
        if mx > plus[index].x - 8 and mx < plus[index].x + 8 and my > plus[index].y - 8 and my < plus[index].y + 8 then
            love.graphics.setColor(255,255,0,255) 
        end
        love.graphics.rectangle("fill", plus[index].x - 2, plus[index].y - 8, 4, 16)
        love.graphics.rectangle("fill", plus[index].x - 8, plus[index].y - 2, 16, 4)
        love.graphics.setColor(255,255,255,255)
    end
end

function drawBagInterface ( bagIndex )
    local width = #bags[bagIndex].loots * 40
    local height = (#bags[bagIndex].loots % 2) * 42 + 42
    love.graphics.rectangle("line", bags[bagIndex].x, bags[bagIndex].y, width, height)
    for i = 1, #bags[bagIndex].loots, 1 do
        if mx > bags[bagIndex].x + 4 * i and mx < (bags[bagIndex].x + (i - 1) * 32 + 4 * i)
        and my > bags[bagIndex].y and my < bags[bagIndex].y + 32
        then
            love.graphics.rectangle("fill", bags[bagIndex].x + (i - 1) * 32 + 4 * i, bags[bagIndex].y + 5, 32, 32)
        else
            love.graphics.rectangle("line", bags[bagIndex].x + (i - 1) * 32 + 4 * i, bags[bagIndex].y + 5, 32, 32)
        end
        if bags[bagIndex].loots[i].texture ~= nil then
            love.graphics.draw(bags[bagIndex].loots[i].texture, bags[bagIndex].x + (i - 1) * 32 + 4 * i, bags[bagIndex].y + 5, 0, 1, 1, 0, 0)
        end
    end
end

function love.draw ()
    if p == true then
        love.graphics.print("PlayerLife : " ..player.life, 0, 0)
        love.graphics.print("PlayerAttackCooldown : " ..player.attack.cooldown, 0, 10)
        love.graphics.print("NextMonster : " ..spawnMonsterTimer, 650, 0)
        love.graphics.print("DamagePerSecond : "..dps, 0, 20)
        love.graphics.print("Max dps : "..maxDps, 0, 30)
    end
    -- Player body drawing
    love.graphics.setColor(255,255,255,255);
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    -- projectiles drawing
    for i, v in ipairs(projectiles) do
        love.graphics.circle("fill", projectiles[i].x, projectiles[i].y, 2);
    end

    -- Monsters drawing
    for i, v in ipairs(monsters) do
        love.graphics.setColor(255,0,0,255);
        love.graphics.rectangle("fill", monsters[i].x, monsters[i].y - 16, monsters[i].w * ( monsters[i].life / 100 ), 8)
        love.graphics.setColor(255,255,255,255);
        love.graphics.rectangle("line", monsters[i].x, monsters[i].y, monsters[i].w, 8)
        love.graphics.rectangle("fill", monsters[i].x, monsters[i].y, monsters[i].w, monsters[i].h);
    end

    -- Draw bags
    for k, bag in pairs(bags) do
        love.graphics.setColor(bag.color[1], bag.color[2], bag.color[3], bag.color[4])
        love.graphics.rectangle("fill", bag.x, bag.y, 16, 16)
        if bag.x + 16 > player.x and bag.x < player.x  + player.w 
        and bag.y + 16 > player.y and bag.y < player.y + player.h then
            drawBagInterface(k)
        end    
    end
    

    -- Interface drawing
    -- Quick Item Interface
    love.graphics.rectangle("line", 250, 600 - 110, 32, 32)
    love.graphics.rectangle("line", 292, 600 - 110, 32, 32)
    love.graphics.rectangle("line", 334, 600 - 110, 32, 32)
    love.graphics.rectangle("line", 376, 600 - 110, 32, 32)
    love.graphics.rectangle("line", 418, 600 - 110, 32, 32)
    love.graphics.rectangle("line", 460, 600 - 110, 32, 32)
    love.graphics.rectangle("line", 502, 600 - 110, 32, 32)
    -- Life
    love.graphics.setColor(255, 0, 0, 255);
    love.graphics.rectangle("fill", 800 / 2 - 150, 600 - 68, 300 * ( player.life / player.stats.max_life ), 32)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", 800 / 2 - 150, 600 - 68, 300, 32)
    -- TODO: Find a font
    love.graphics.print(player.life .. " / " .. player.stats.max_life, 800 / 2 - 150, 600 - 68)
    -- Mana   
    love.graphics.setColor(0,255,200,255);
    love.graphics.rectangle("fill", 564, 600 - 74, 64, 64)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", 564, 600 - 74, 64, 64 * ( player.mana / 100 ))
    -- Experience
    love.graphics.setColor(128, 0, 128, 255);
    love.graphics.rectangle("fill", 800 / 2 - 150, 600 - 26, 300 * ( player.exp / player.maxExp ), 16)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", 800 / 2 - 150, 600 - 26, 300, 16)


    -- PlAYER
    if charInterface.show then
        -- Button
        love.graphics.setColor(128, 0, 128, 255);
        love.graphics.rectangle("fill", 10, 600 - 32 - 10, 32, 32)

        -- INTERFACE
        love.graphics.setColor(255, 255, 255, 255);
        love.graphics.rectangle("line", 10, 600 - 272, 220, 220);
        love.graphics.print("Player stats", 10, 308)
        
        love.graphics.print("Max life : "..player.stats.max_life, 40, 338)
        drawPlus(1)
        love.graphics.print("Max mana : "..player.stats.max_mana, 40, 358)
        drawPlus(2)
        love.graphics.print("Attack : "..player.stats.attack, 40, 378)
        drawPlus(3)
        love.graphics.print("Defense : "..player.stats.defense, 40, 398)
        drawPlus(4)
        love.graphics.print("Wisdom : "..player.stats.wisdom, 40, 418)
        drawPlus(5)
        love.graphics.print("Dexterity : "..player.stats.dexterity, 40, 438)
        drawPlus(6)
        love.graphics.print("Speed : "..player.stats.speed, 40, 458)
        drawPlus(7)
        love.graphics.print("Force : "..player.stats.force, 40, 478)
        drawPlus(8)
    else
        love.graphics.setColor(255, 255, 255, 255);
        love.graphics.print("C", 16, 600-32)
        love.graphics.rectangle("line", 10, 600 - 32 - 10, 32, 32)
    end
    -- BAG
    if bagInterface.show then
        -- Bag Icon
        love.graphics.setColor(128, 0, 128, 255);
        love.graphics.rectangle("fill", 20 + 32, 600 - 32 - 10, 32, 32)
        -- Bag Interface
        love.graphics.setColor(255, 255, 255, 255);
        love.graphics.rectangle("line", 10, 600- 52 - 220, 220, 220);
        love.graphics.print("Bag : "..#player.bag.." items.", 10, 600-52-240)
        for y = 1, 5, 1 do
            for x = 1, 5, 1 do
                love.graphics.rectangle("line", 20 + (10 + 32) * (x - 1), (600 - 94 - 210 ) + 42 * y, 32, 32)
            end
        end
        love.graphics.print("Bag : "..#player.bag.." items.", 10, 600-52-240)
    else
        love.graphics.setColor(255, 255, 255, 255);
        love.graphics.print("B", 64, 600-32)
        love.graphics.rectangle("line", 20 + 32, 600 - 32 - 10, 32, 32)
    end
end

local lshift = false
function love.keypressed (key)
   if key == "lshift" then lshift = true end
    if key == "b" then 
        if bagInterface.show == false then
            bagInterface.show = true
            charInterface.show = false
        else
            bagInterface.show = false
        end
    end
    if key == "c" then
        if charInterface.show then
            charInterface.show = false
        else
            charInterface.show = true
            bagInterface.show = false
        end
    end
    if key == "p" then
        p = true;
    end
end

function love.keyrelease (key)
   if key == "lshift" then lshift = false end
   if key == "p" then p = false end
end

function love.mousepressed (mx, my, button)
    if player.statPoints > 0 then
        for i, v in ipairs(plus) do
            if mx > plus[i].x - 8 and mx < plus[i].x + 8 and my > plus[i].y - 8 and my < plus[i].y + 8 then
                if button == 1 then
                    if lshift ~= false then
                        if plus[i].name == "max_life" or plus[i].name == "max_mana" then
                            player.stats[plus[i].name] = player.stats[plus[i].name] + player.statPoints * 5;
                        else
                            player.stats[plus[i].name] = player.stats[plus[i].name] + player.statPoints;
                        end
                        player.statPoints = 0;
                    else
                        if plus[i].name == "max_life" or plus[i].name == "max_mana" then
                            player.stats[plus[i].name] = player.stats[plus[i].name] + 5;
                        else
                            player.stats[plus[i].name] = player.stats[plus[i].name] + 1;
                        end
                        player.statPoints = player.statPoints - 1;
                    end
                end
            end
        end
    end
end

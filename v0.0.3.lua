_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.engineDir      = _G.baseDir .. "engine."
_G.libDir = _G.baseDir .. "lib."

local JSON = require("lib.json")

local ok, err = love.filesystem.read("src/assets/prefabs/dat1.json")
local dat = JSON:decode(ok).Object
local loadedTextures = {}
local validData = {}

for index, value in ipairs(dat) do
    --#region LOADING TEXTURES
    for key, v in pairs(value) do
        -- Load textures
        if key == "Texture" then
            if loadedTextures[v.File] == nil and v.File ~= "invisible" and v.File ~= "lofiChar8x8" and v.File ~= "lofiChar216x8" and v.File ~= "lofiChar216x16"  and v.File ~= "lofiChar16x16"  and v.File ~= "lofiChar16x8"  and v.File ~= "lofiChar28x8"  and v.File ~= "d1lofiObjBig" then
                validData[#validData + 1] = dat[index]
                if string.find(v.File, "Embed") then
                    loadedTextures[v.File] = love.graphics.newImage("src/assets/textures/rotmg/EmbeddedAssets_" .. v.File .. "_.png")
                else
                    loadedTextures[v.File] = love.graphics.newImage("src/assets/textures/rotmg/EmbeddedAssets_" .. v.File .. "Embed_.png") or nil
                end
            end
        end
    end
    --#endregion

end
love.graphics.setDefaultFilter("nearest")

local player = {
    x = 0,
    y = 0,
    w = 32,
    h = 64,
    speed = 5,
    level = 1,
    exp = 0,
    maxExp = 100,
    statPoints = 10,
    spell = {
        current = "",
        cooldown = 20
    },
    skin = {
        animations = {
            current = "top",
            
            top = { 49, 50, 51 }
        },
        texture = love.graphics.newImage("src/assets/textures/rotmg/EmbeddedAssets_playersSkins16Embed_.png")
    },
    isDeath = false,
    stats = {
        life = 100,
        mana = 100,
        max_life = 100,
        max_mana = 100,
        attack = 1,
        wisdom = 1,
        force = 1,
        dexterity = 1,
        speed = 1,
        defense = 1
    },
    sound = {
        death = love.audio.newSource("src/assets/sfx/player/knight_death.mp3", "static"),
        hit = love.audio.newSource("src/assets/sfx/player/knight_hit.mp3", "static")
    },
    attack = {
        cooldown = 20,
        damage = 10
    },
    equipement = {
        hat = nil,
        chest = nil,
        spell = nil,
        ring = nil
    },
    bag = {},
}

local function addPlayerLife ( life )
    if  player.stats.life + life > player.stats.max_life then
        player.stats.life = player.stats.max_life
    else
        player.stats.life = player.stats.life + life
    end
end

local function addPlayerMana ( mana )
    if  player.stats.mana + mana > player.stats.max_mana then
        player.stats.mana = player.stats.max_mana
    else
        player.stats.mana = player.stats.mana + mana
    end
end

local bagInterface = {
    show = false
}

local charInterface = {
    show = false
}

local function addPlayerStats ( stats )
    for k, v in pairs(stats) do
        player[k] = player[k] + v
    end
end

local items = {
    { name = "sword_1", type="weapon", rarity = 4, texture = nil },
    { name = "sword_2", type="weapon", rarity = 4, texture = nil },
    { name = "sword_3", type="weapon", rarity = 4, texture = nil },
    { name = "sword_4", type="weapon", rarity = 3, texture = nil },
    { name = "sword_5", type="weapon", rarity = 4, texture = nil },
    { name = "sword_6", type="weapon", rarity = 4, texture = nil },
    { name = "sword_7", type="weapon", rarity = 2, texture = nil },
    { name = "sword_8", type="weapon", rarity = 1, texture = nil },
    { name = "health_potion", stackable = 8, type="quick_slot", rarity = 0, texture = love.graphics.newImage("src/assets/textures/hp.png"), use = { destroy = true, handler = function () addPlayerLife(100) end, sound = love.audio.newSource("src/assets/sfx/use_potion.mp3", "static") }},
    { name = "mana_potion", stackable = 8, type="quick_slot", rarity = 0, texture = love.graphics.newImage("src/assets/textures/mp.png"),  use = { destroy = true, handler = function () addPlayerMana(100) end, sound = love.audio.newSource("src/assets/sfx/use_potion.mp3", "static") }}
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

local monsters = {}
local projectiles = {}

local levelUpSound = love.audio.newSource("src/assets/sfx/level_up.mp3", "static")
local windowWidth, windowHeight, t = love.window.getMode();

local spawnMonsterTimer = 100;
local monsterKilled = 0;
local dps = 0
local autoAttack = false
local p = false
local lshift = false
local lastLeftMouseClick = love.timer.getTime()
local leftClickCount = 0
local lastRightMouseClick = love.timer.getTime()
local rightClickCount = 0
local leftMouseButtonPressed = false
local rightMouseButtonPressed = false
local itemInMouse = nil
local dpsTimer = 1
local maxDps = 0
local mx, my = 0, 0

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
            loots = { { name = "health_potion", quantity = 2 }, "mana_potion" }
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

--#region Functions
local function dropBag (x, y, loots)
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
    for k, loot in pairs(loots) do
        for itemIndex, itemValue in ipairs(items) do
            if type(loot) == "table" then
                if itemValue.name == loot.name then
                    newBag.loots[#newBag.loots + 1] = { item = itemValue, quantity = loot.quantity }
                end
            else
                if itemValue.name == loot then
                    newBag.loots[#newBag.loots + 1] = { item = itemValue, quantity = 1 }
                end
            end
            if itemValue.rarity > newBag.rarity then
                newBag.rarity = itemValue.rarity
            end
        end
    end

    newBag.name = bagTypes[newBag.rarity..""].name
    newBag.texture = bagTypes[newBag.rarity..""].texture
    newBag.color = bagTypes[newBag.rarity..""].color

    table.insert(bags, #bags + 1, newBag)
end

local function createMonster( monsterTemplate , x, y)
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
            deathSound = love.audio.newSource("src/assets/sfx/monster/".. monsterTemplate.name .."_death.mp3", "static"),
            hitSound = love.audio.newSource("src/assets/sfx/monster/".. monsterTemplate.name .."_hit.mp3", "static")
        },
        attack = {
            cooldown = 50,
            damage = monsterTemplate.damage or 5
        },
        dexterity = 4,
    }
end

local function monstersUpdate()
    if #monsters < 5 and monsterKilled < 3 then
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
                if player.stats.life > 0 then
                    player.stats.life = player.stats.life - monsters[i].attack.damage;
                    player.sound.hit.play(player.sound.hit)
                end
                monsters[i].attack.cooldown = 100
            end
        else
            monsters[i].isInCollision = false
        end
    end
end

local function createProjectiles ( sx, sy, dx, dy, damage )
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

local function playerUpdate ()
    local z = love.keyboard.isDown("z");
    local w = love.keyboard.isDown("w");
    local q = love.keyboard.isDown("q");
    local a = love.keyboard.isDown("a");
    local d = love.keyboard.isDown("d");
    local s = love.keyboard.isDown("s");
    if z or w then
        player.y = player.y - (player.speed + player.stats.speed * 0.1);
    end

    if q or a then
        player.x = player.x - (player.speed + player.stats.speed * 0.1);
    end


    -- Level up
    local restExp = player.exp - player.maxExp
    if restExp >= 0 then
        player.exp = restExp
        player.level = player.level + 1;
        player.stats.life = player.stats.max_life;
        player.statPoints = player.statPoints + 1;
        levelUpSound.play(levelUpSound)
    end

    if player.stats.life < 1 then
        -- player.sound.death.play(player.sound.death)
    end
end

local function projectilesUpdate ()
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
                    monsterKilled = monsterKilled + 1
                    dropBag(monsters[mi].x, monsters[mi].y, monsters[mi].reward.loots)
                    table.remove(monsters, mi)
                end
            end
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


local function drawPlus ( index )
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

local function drawBagInterface ( bagIndex )
    local width = #bags[bagIndex].loots * 40
    local height = #bags[bagIndex].loots % 2 * 42 + 42
    if #bags[bagIndex].loots % 2 == 0 then height = (#bags[bagIndex].loots % 2) * 42 + 42 else height = #bags[bagIndex].loots % 2 * 42 end
    love.graphics.rectangle("line", bags[bagIndex].x, bags[bagIndex].y, width, height)
    for i = 1, #bags[bagIndex].loots, 1 do
        bags[bagIndex].isShown = true
        if mx > bags[bagIndex].x + (i - 1) * 32 + 4 * i and mx < bags[bagIndex].x + (32 * i) + 4 * i
            and my > bags[bagIndex].y and my < bags[bagIndex].y + 32
        then
            love.graphics.rectangle("fill", bags[bagIndex].x + (i - 1) * 32 + 4 * i, bags[bagIndex].y + 5, 32, 32)
        else
            love.graphics.rectangle("line", bags[bagIndex].x + (i - 1) * 32 + 4 * i, bags[bagIndex].y + 5, 32, 32)
        end
        if bags[bagIndex].loots[i].item.texture ~= nil then
            local quad = love.graphics.newQuad(
                0,
                0,
                64, 32,
                bags[bagIndex].loots[i].item.texture:getDimensions()
            )
            if bags[bagIndex].loots[i].quantity > 1 then
                love.graphics.print(
                    bags[bagIndex].loots[i].quantity,
                    bags[bagIndex].x + (i - 1) * 32 + 4 * i,
                    bags[bagIndex].y + 5
                )
            end
            love.graphics.draw(
                bags[bagIndex].loots[i].item.texture,
                quad,
                bags[bagIndex].x + (i - 1) * 32 + 4 * i,
                bags[bagIndex].y + 5,
                0,
                1.5, 1.5,
                0, 0,
                0, 0
            )
        end
    end
end

local buttonsForSlots = {
    ["quick_slot_1"] = "f",
    ["quick_slot_2"] = "a",
    ["quick_slot_3"] = "e",
    ["head"] = "1",
    ["spell"] = "2",
    ["chest"] = "3",
    ["ring"] = "4",
}

local quickSlots = {
    { type = "quick_slot", key="f", item = nil },
    { type = "quick_slot", key="a", item = nil },
    { type = "quick_slot", key="e", item  = nil },
    { type = "head", item = nil },
    { type = "spell", item = nil },
    { type = "chest", item = nil },
    { type = "ring", item = nil },
}
--#endregion
local function drawQuickSlots ()
    for i, v in ipairs(quickSlots) do
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("line", 250 + (i - 1) * 42, 600 - 110, 32, 32)
        if quickSlots[i].item ~= nil and quickSlots[i].quantity ~= 0 and quickSlots[i].quantity ~= nil then
            love.graphics.print(""..quickSlots[i].quantity, 250 + (i - 1) * 42, 600 - 110)
            local quad = love.graphics.newQuad(
                0,
                0,
                64, 32,
                quickSlots[i].item.texture:getDimensions()
            )
            love.graphics.draw(
                quickSlots[i].item.texture,
                quad,
                250 + (i - 1) * 42,
                600 - 110,
                0,
                1.5, 1.5,
                0, 0,
                0, 0
            )
        end
    end
end
function love.load ( config )
    config.title = "RPG"
end

function love.update ( dt )
    if love.timer.getTime() - lastLeftMouseClick > 1 then
        leftClickCount = 0
        lastLeftMouseClick = love.timer.getTime()
    end
    if love.timer.getTime() - lastRightMouseClick > 1 then
        rightClickCount = 0
        lastRightMouseClick = love.timer.getTime()
    end
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

    for i, v in ipairs(bags) do
        if #v.loots < 1 then
            table.remove(bags, i)
        end
    end

    

end

function love.draw ()
    for index, value in ipairs(validData) do
        --#region LOADING TEXTURES
        if index < 25 then
            for key, v in pairs(value) do
                -- Load textures
                if key == "Texture" then
                    local w, h = loadedTextures[v.File]:getDimensions()
                    local ny = math.floor(tonumber(v.Index) / (w / 8))
                    local nx = math.floor((tonumber(v.Index) * 8) - (w * ny))
                    local quad = love.graphics.newQuad(nx, ny, 8, 8, loadedTextures[v.File]:getDimensions())
                    love.graphics.draw(loadedTextures[v.File], quad, 32 * index, 32 * (index % 2), 0, 2,2,0,0,0,0)
                end
            end
        end
        --#endregion
    end
    if player.isDeath then
        love.graphics.print("DEAD", 800/2, 600/2)
    end
    if p == true then
        love.graphics.print("PlayerLife : " ..player.stats.life, 0, 0)
        love.graphics.print("PlayerAttackCooldown : " ..player.attack.cooldown, 0, 10)
        love.graphics.print("NextMonster : " ..spawnMonsterTimer, 650, 0)
        love.graphics.print("DamagePerSecond : "..dps, 0, 20)
        love.graphics.print("Max dps : "..maxDps, 0, 30)
    end
    -- Player body drawing
    love.graphics.setColor(255,255,255,255);
    -- love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    local w, h = player.skin.texture:getDimensions()
    local ny = math.floor(65 * 16 / (w / 16))
    local nx = math.floor(65 * 16 - (w * ny))
    local quad = love.graphics.newQuad(0, 0, 16, 16, w, h)
    love.graphics.draw(player.skin.texture, quad, player.x, player.y, 0, 2,2,0,0)

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
    local moreShorter = nil
    for bagIndex, bag in ipairs(bags) do
        love.graphics.setColor(bag.color[1] / 255, bag.color[2] / 255, bag.color[3] / 255, bag.color[4] / 255)
        love.graphics.rectangle("fill", bag.x, bag.y, 16, 16)
        love.graphics.setColor(1,1,1,1)
        if itemInMouse ~= nil and itemInMouse.lastBag == bagIndex then
            love.graphics.rectangle("line", bag.x-2, bag.y-2, 20, 20)
        end
        if bag.x + 16 > player.x and bag.x < player.x  + player.w
        and bag.y + 16 > player.y and bag.y < player.y + player.h then
            drawBagInterface(bagIndex)
        end
    end

    -- Draw item in mouse
    if itemInMouse ~= nil then
        local quad = love.graphics.newQuad(
                0,
                0,
                64, 32,
                itemInMouse.item.texture:getDimensions()
            )
            love.graphics.draw(
                itemInMouse.item.texture,
                quad,
                mx + 5,
                my + 5,
                0,
                1.5, 1.5,
                0, 0,
                0, 0
            )
    end
    

    -- Interface 
    -- Quick Item Interface
    drawQuickSlots()
    -- Life
    love.graphics.setColor(255, 0, 0, 255);
    love.graphics.rectangle("fill", 800 / 2 - 150, 600 - 68, 300 * ( player.stats.life / player.stats.max_life ), 32)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", 800 / 2 - 150, 600 - 68, 300, 32)
    -- TODO: Find a font
    love.graphics.print(player.stats.life .. " / " .. player.stats.max_life, 800 / 2 - 150, 600 - 68)
    -- Mana   
    love.graphics.setColor(0,255,200,255);
    love.graphics.rectangle("fill", 564, 600 - 74, 64, 64)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", 564, 600 - 74, 64, 64 * ( player.stats.mana / 100 ))
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
    for i, v in ipairs(quickSlots) do
        if v.key ~= nil then
            if key == v.key then
                if v.item ~= nil then
                    if v.item.use ~= nil then
                        if v.item.use.destroy == true then
                            print(quickSlots[i].quantity )
                            quickSlots[i].quantity = quickSlots[i].quantity - 1
                            print(quickSlots[i].quantity )
                        end
                        v.item.use.handler()
                    end
                end
            end
        end
    end
    if key == "p" then
        local p = true;
    end
end

function love.keyrelease (key)
   if key == "lshift" then lshift = false end
   if key == "p" then p = false end
end

function love.mousereleased (mx, my, button)
    if button == 1 then
        lastLeftMouseClick = love.timer.getTime() - lastLeftMouseClick
        leftMouseButtonPressed = false
    end if button == 2 then
        --right click when hover item should take one item in quantity if quantity is > 1
        lastRightMouseClick = love.timer.getTime() - lastRightMouseClick
        rightMouseButtonPressed = false
    end
    if leftMouseButtonPressed == false then
        if itemInMouse ~= nil then
            local slotToDrop = nil
            for i, v in ipairs(quickSlots) do
                if mx > 250 + (i - 1) * 42 and mx < 250 + (i - 1) * 42 + 32 and my > 600 - 110 and my < 600 - 110 + 32 then
                    slotToDrop = i
                end
            end
            if slotToDrop ~= nil then
                if itemInMouse.item.type == quickSlots[slotToDrop].type then
                    if quickSlots[slotToDrop].item ~= nil then
                        if quickSlots[slotToDrop].item.name == itemInMouse.item.name then
                            -- Item quantity
                            if quickSlots[slotToDrop].quantity < itemInMouse.item.stackable then
                                local toRetain = 0
                                if itemInMouse.quantity + quickSlots[slotToDrop].quantity > itemInMouse.item.stackable then
                                    toRetain = itemInMouse.quantity - quickSlots[slotToDrop].quantity
                                end
                                quickSlots[slotToDrop].quantity = quickSlots[slotToDrop].quantity + itemInMouse.quantity
                                itemInMouse = nil
                                slotToDrop = nil
                            end
                        else
                            local stock = quickSlots[slotToDrop]
                            quickSlots[slotToDrop] = { item = itemInMouse.item, quantity = itemInMouse.quantity }
                            itemInMouse = { item = stock.item, quantity = stock.quantity, lastBag = nil }
                            slotToDrop = nil
                        end
                    else
                        quickSlots[slotToDrop].item = itemInMouse.item
                        quickSlots[slotToDrop].quantity = itemInMouse.quantity
                        itemInMouse = nil
                        slotToDrop = nil
                    end
                end
            else
                if itemInMouse.lastBag ~= nil then
                    if bags[itemInMouse.lastBag] ~= nil then
                        
                        table.insert(bags[itemInMouse.lastBag].loots, #bags[itemInMouse.lastBag].loots, { item = itemInMouse.item, quantity = itemInMouse.quantity })
                        itemInMouse = nil
                    else
                        dropBag(mx, my, {{ item = itemInMouse.item.name, quantity = itemInMouse.quantity }})
                        itemInMouse = nil
                    end
                end
            end
        end
    end

    for i, v in ipairs(quickSlots) do
        if quickSlots[i].item ~= nil and quickSlots[i].quantity ~= nil then
            if quickSlots[i].quantity < 1 then
                quickSlots[i].item = nil
            end
        end
    end
end

function love.mousepressed (mx, my, button)
    if button == 1 then
        leftClickCount = leftClickCount + 1
        leftMouseButtonPressed = true
    end if button == 2 then
        rightClickCount = rightClickCount + 1
        rightMouseButtonPressed = true
    end
    for bagIndex, bag in pairs(bags) do
        if  bag.x + 16 > player.x and bag.x < player.x  + player.w and
            bag.y + 16 > player.y and bag.y < player.y + player.h then

            for i = 1, #bags[bagIndex].loots, 1 do
                if mx > bags[bagIndex].x + (i - 1) * 32 + 4 * i and mx < bags[bagIndex].x + (32 * i) + 4 * i
                and my > bags[bagIndex].y and my < bags[bagIndex].y + 32
                then
                    if leftMouseButtonPressed then
                        if itemInMouse == nil then
                            itemInMouse = {
                                item = bags[bagIndex].loots[i].item,
                                quantity = bags[bagIndex].loots[i].quantity,
                                lastBag = bagIndex
                            }
                            table.remove( bags[bagIndex].loots, i)
                        end
                    end
                end
            end
        end
    end
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
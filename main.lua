_G.baseDir      = (...):match("(.-)[^%.]+$")
_G.engineDir      = _G.baseDir .. "engine."

local player = {
    x = 0,
    y = 0,
    w = 32,
    h = 64,
    mana = 100,
    speed = 5,
    level = 1,
    exp = 10,
    maxExp = 100,
    life = 100,
    statPoints = 0,
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
        cooldown = 100,
        damage = 10
    },
    bag = {}
}

local bagInterface = {
    show = false
}

local charInterface = {
    show = false
}

local monsters = {}
local projectiles = {}

local windowWidth, windowHeight, t = love.window.getMode(); 
function love.load ( config )
    config.title = "RPG"
    for k, v in pairs(love.audio) do
        -- body
    end
end

function createMonster(x, y, damage)
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
        reward = {
            exp = love.math.random(0, 20),
            bag = "white"
        },
        music = {
            deathSound = love.audio.newSource("sfx/monster/bats_death.mp3", "static"),
            hitSound = love.audio.newSource("sfx/monster/bats_hit.mp3", "static")
        },
        attack = {
            cooldown = 50,
            damage = damage or 5
        },
        dexterity = 4,
    }
end

local spawnMonsterTimer = 100;
function monstersUpdate()
    if #monsters < 5 then
        if spawnMonsterTimer < 1 then
            table.insert(monsters, #monsters + 1, createMonster())
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
                player.life = player.life - monsters[i].attack.damage;
                monsters[i].attack.cooldown = 100
            end
        else
            monsters[i].isInCollision = false
        end
    end
end

function createProjectiles ( x, y, damage )
    return {
        x = player.x,
        y = player.y,
        w = 4,
        h = 4,
        damage = damage or player.attack.damage,
        velocity = {
            x = math.cos(math.atan2(y - player.y, x - player.x)),
            y = math.sin(math.atan2(y - player.y, x - player.x))
        }
    }
end

function playerUpdate ()
    local z = love.keyboard.isDown("z");
    local q = love.keyboard.isDown("q");
    local d = love.keyboard.isDown("d");
    local s = love.keyboard.isDown("s");
    if z then
        player.y = player.y - player.speed;
    end

    if q then
        player.x = player.x - player.speed;
    end

    if d then
        player.x = player.x + player.speed;
    end

    if s then
        player.y = player.y + player.speed;
    end

    local rest = player.exp - player.maxExp
    if rest >= 0 then
        player.exp = rest 
        player.level = player.level + 1;
        player.statPoints = player.statPoints + 1;
    end
end

function dropBag (type, x, y)
    local newBag = {
        x = x,
        y = y,
        type = type,
    }
    table.insert(bags, #bags, newBag)
end

function projectilesUpdate ()
    local mouseIsDown = love.mouse.isDown(1);
    local x, y = love.mouse.getPosition();
    if player.attack.cooldown == 0 and mouseIsDown then
        table.insert(projectiles, #projectiles + 1, createProjectiles(x, y))
        player.attack.cooldown = 20
    end
    if player.attack.cooldown > 0 then
        player.attack.cooldown = player.attack.cooldown - 1;
    end
    -- Move projectiles by velocity
    for i, v in ipairs(projectiles) do
        projectiles[i].x = projectiles[i].x + ( projectiles[i].velocity.x * 10 )
        projectiles[i].y = projectiles[i].y + ( projectiles[i].velocity.y * 10 )
    end
    -- Remove bullet in contact
    for mi, v in ipairs(monsters) do
        for bi, v in ipairs(projectiles) do
            if monsters[mi].x + monsters[mi].w >= projectiles[bi].x and monsters[mi].x <= projectiles[bi].x + projectiles[bi].w
            and monsters[mi].y + monsters[mi].h >= projectiles[bi].y and monsters[mi].y <= projectiles[bi].y + projectiles[bi].h
            then
                monsters[mi].life = monsters[mi].life - projectiles[bi].damage;
                monsters[mi].music.hitSound.play(monsters[mi].music.hitSound);
                table.remove(projectiles, bi);
                if monsters[mi].life <= 0 then
                    monsters[mi].music.deathSound.play(monsters[mi].music.deathSound);
                    player.exp = player.exp + monsters[mi].reward.exp
                    dropBag(player.x, player.y)
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

local mx, my = 0, 0
function love.update ( dt )
    mx, my = love.mouse.getPosition()
    playerUpdate();
    projectilesUpdate();
    monstersUpdate();

end


function updatePlus ()
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



function love.draw ()
    love.graphics.print("PlayerLife : " ..player.life, 0, 0)
    love.graphics.print("PlayerAttackCooldown : " ..player.attack.cooldown, 0, 10)
    love.graphics.print("NextMonster : " ..spawnMonsterTimer, 650, 0)

    -- Player drawing
    love.graphics.setColor(255,255,255,255);
    love.graphics.rectangle("line", player.x, player.y - 32, player.w, player.w / 4)
    love.graphics.setColor(0,255,200,255);
    love.graphics.rectangle("fill", player.x, player.y - 32, player.w * ( player.life / 100 ), player.w / 4)
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

    -- Interface drawing
    -- Life
    love.graphics.setColor(255, 0, 0, 255);
    love.graphics.rectangle("fill", 800 / 2 - 150, 600 - 68, 300 * ( player.life / 100 ), 32)
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", 800 / 2 - 150, 600 - 68, 300, 32)
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
end

function love.keyrelease (key)
   if key == "lshift" then lshift = false end
end

function love.mousepressed (mx, my, button)
    if player.statPoints > 0 then
        for i, v in ipairs(plus) do
            if mx > plus[i].x - 8 and mx < plus[i].x + 8 and my > plus[i].y - 8 and my < plus[i].y + 8 then
                if button == 1 then
                    if lshift then
                        player.stats[plus[i].name] = player.stats[plus[i].name] + player.statPoints;
                        player.statPoints = 0;
                    else
                        player.stats[plus[i].name] = player.stats[plus[i].name] + 1;
                        player.statPoints = player.statPoints - 1;
                    end
                end
            end
        end
    end
end
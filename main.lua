-- EXP -> LEVEL UP -> POINT DE COMPETENCES 
-- INTERFACE -> BAGS, CHARACTERISTIC
-- BONUS: PETS / MOUNTS

local player = {
    x = 0,
    y = 0,
    w = 32,
    h = 64,
    mana = 100,
    speed = 5,
    exp = 10,
    maxExp = 100,
    life = 100,
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
        print(k)
    end
end

local bags = {};

local bagTypes = {
    white = {
        texture = "",
        color = "white",
        itemRarity = 5
    }
}

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
        monsters[i].x = monsters[i].x - monsters[i].velocity.x * 1
        monsters[i].y = monsters[i].y - monsters[i].velocity.y * 1
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

function love.update ( dt )
    playerUpdate();
    projectilesUpdate();
    monstersUpdate();
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
        love.graphics.setColor(128, 0, 128, 255);
        love.graphics.rectangle("fill", 10, 600 - 32 - 10, 32, 32)
    end
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", 10, 600 - 32 - 10, 32, 32)

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
    end
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle("line", 20 + 32, 600 - 32 - 10, 32, 32)

end

function love.keypressed (key)
    if key == "b" then 
        if bagInterface.show == false then
            bagInterface.show = true
        else
            bagInterface.show = false
        end
    end
    if key == "c" then
        if charInterface.show then
            charInterface.show = false
        else
            charInterface.show = true
        end
    end
end

Enemy = {}
enemies = {}
maxEnemies = 15
Enemy.__index = Enemy

planets = {
    small = {
        {name = "earth", topLeft = 80, size = 1 },
        {name = "mars", topLeft = 64, size = 1 },
        {name = "brown", topLeft = 96, size = 1},
        {name = "sm sun", topLeft = 112, size = 1}
    },
    medium = {
        {name = "md jupiter", topLeft = 65, size = 2},
        {name = "md asteroid", topLeft = 67, size = 2},
        {name = "md ice-earth", topLeft = 99, size = 2 },
        {name = "md gray", topLeft = 97, size = 2, size = 2}
    }

}


function getRandomEnemy(planets)
    local size = rnd({"small", "medium"})
    local enemyList = planets[size]
    local enemy = rnd(enemyList)

    enemy.size = size 
    return enemy
end




function Enemy:init()

    for i=1,maxEnemies do
        Enemy:new()
end



end


function Enemy:new()
    local e = setmetatable({}, Enemy)

    e.x = flr(rnd(maxWidth))
    e.y = flr(rnd(maxHeight))
    e.alive = true

    -- dirección aleatoria
    local angle = rnd(1)
    local speed = 2
    e.dx = cos(angle)*speed
    e.dy = sin(angle)*speed

    e.planet = getRandomEnemy(planets)

    if e.planet.size == "medium" then
        e.health = 3
    else
        e.health = 1
    end

    add(enemies, e)
    return e


end


function Enemy.update()
    Enemy:movement()
    Enemy:checkBulletCollision()
end


function Enemy:draw()
    for e in all(enemies) do

        if e.planet.size == "medium" then
            spr(e.planet.topLeft, e.x, e.y, 2, 2)
        else
            spr(e.planet.topLeft, e.x, e.y)
        end 
end
end


function Enemy:movement()
    for e in all(enemies) do
        e.x += e.dx
        e.y += e.dy
        self:colisionMapa(e)
        self:handleDead()
        self:respawnEnemies()

    end

end

function Enemy:colisionMapa(e)
    if e.x<0 then
            e.x=0
            e.dx = -e.dx
        elseif e.x>maxWidth then
            e.x=maxWidth
            e.dx = -e.dx
        end

        -- rebote vertical
        if e.y<0 then
            e.y=0
            e.dy = -e.dy
        elseif e.y>maxHeight then
            e.y=maxHeight
            e.dy = -e.dy
        end
end

function Enemy:handleDead()
    for i=#enemies,1,-1 do
        if not enemies[i].alive then
        deli(enemies,i)
        end
    end
end

function Enemy:respawnEnemies()
     while #enemies < maxEnemies do
        self:new()
    end
end


function checkCollision(b, e)
    local ex = e.x
    local ey = e.y
    local bw = (e.planet.size == "medium") and 16 or 8
    local bh = bw

    -- Comprobación de bounding box entre bala y enemigo
    return b.x > ex and b.x < ex + bw and b.y > ey and b.y < ey + bh
end


function Enemy:checkBulletCollision()
    for e in all(enemies) do
        for b in all(Bullets) do
            if b.live and checkCollision(b, e) then
                sfx(sfxHit)
                e.health -= 1
                b.live = false -- marca la bala para eliminarla
                if e.health <= 0 then
                    e.alive = false
                    Explosion:new(e)
                end
            end
        end
    end
end
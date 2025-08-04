Enemy = {}
enemies = {}
maxEnemies = 15
Enemy.__index = Enemy


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
    local speed = 1
    e.dx = cos(angle)*speed
    e.dy = sin(angle)*speed

    add(enemies, e)
    return e


end


function Enemy.update()
    Enemy:movement()
end


function Enemy:draw()
    for e in all(enemies) do
        circfill(e.x, e.y, 4, 8)
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

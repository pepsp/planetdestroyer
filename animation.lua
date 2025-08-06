Explosion = {}
explosions = {}

function Explosion:update()
    self:animateExplosions()
    self:removeExplosions()
end


function Explosion:draw()

    for e in all(explosions) do

        if e.size == "small" then
            spr(e.frame, e.x, e.y)
        else
            spr(e.frame, e.x, e.y, 2, 2)
        end
    end

end

function Explosion:new(e)

    if e.planet and e.planet.size== "medium"  then
        local explosion = {
            size = "medium",
            x = e.x,
            y = e.y,
            frame = mediumExplosionFirstFrame,
            timer = 0,
            done = false

        }
        add (explosions, explosion)
    else
        local explosion = {
            size = "small",
            x = e.x,
            y = e.y,
            frame = smallExplosionFirstFrame,
            timer = 0,
            done = false

        }
        add (explosions, explosion)
end
end


function Explosion:animateExplosions()
    for e in all(explosions) do
    e.timer += 1
        if e.timer > 5 then
            e.timer = 0
        
        if e.size == "small" then
            e.frame += 1

            if e.frame > smallExplosionLastFrame then
                e.done = true
            end
        end

        if e.size == "medium"  then
            e.frame += 2
            if e.frame > mediumExplosionLastFrame then
                e.done = true
            end
        end
        end
    end
end

function Explosion:removeExplosions()

    for i = #explosions, 1, -1 do
        if explosions[i].done then
            deli(explosions, i)
        end
    end

end

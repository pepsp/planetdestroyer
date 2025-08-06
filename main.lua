
--  fix later globalHighscore = highscore
function _init()
    maxWidth = 1024
    maxHeight = 512
    cls()
    srand(time)
    player = {}
    maxHealth = 2
    health = maxHealth
    heartSprite = 24
    enemy = {}
    stars = {}
    maxStars = 200

    score = 0
    highscore = 0

    initStars()
    setmetatable(enemy, {__index = Enemy})
    setmetatable(player, {__index = Player})


    player:init()
    Enemy:init()
    music(0, 0)

    sfxDisparo = 20
    sfxChoque =  21
    sfxHit = 22
    sfxExplosion = 24

    -- animation frames index
    smallExplosionFirstFrame = 17
    smallExplosionLastFrame = 20
    mediumExplosionFirstFrame = 32
    mediumExplosionLastFrame = 38

    cx = 0
    cy = 0


end





function _update()
    player:update()
    Enemy:update()
    Explosion:update()
   keepHighscore()

    dCam()

     for b in all(Bullets) do
        b:update()
        if not b.live then
            del(Bullets, b)
        end

    end
end

function _draw()
    cls()
    map()


    
    player:draw()
    Enemy:draw()
    Explosion:draw()
    drawStars()

     for b in all(Bullets) do
        b:draw()
    end

   print("SCORE: " .. score, cx + 50, cy, 7)
   displayHealth()




end


function dCam()
    cx = player.x + 8 - 63
    cy = player.y + 8 - 63
    camera(cx, cy)
end


function initStars()
    for i=1, maxStars do
        add(stars, {
            x = flr(rnd(maxWidth)),
            y = flr(rnd(maxHeight)),
            c = 7  
        })
    end
end

function drawStars()
    for star in all(stars) do
        pset(star.x, star.y, star.c)
    end
end

function keepHighscore ()
    if score > highscore then
        highscore = score
    end
end


function displayHealth()
    for i = 0, health do
        spr(heartSprite, cx + 2 + i * 9, cy + 2)
    end
end
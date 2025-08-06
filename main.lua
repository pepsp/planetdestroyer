

function _init()
    updateFn = updateMenu
    drawFn = drawMenu
end

function _update()
    updateFn()
end

function _draw()
    drawFn()
end



-- MENU STATE 
function updateMenu()
    if btn(5) then
    
        updateFn = updateGame
        drawFn = drawGame
        gameInit()
        
    end
end

function drawMenu()

      cls()
      spr(1, 60, 25)
    print("planet destroyer", 30, 50)
    
    -- Parpadea cada 0.5 segundos
    if flr(time() * 2) % 2 == 0 then
        print("PRESS x TO START", 30, 100)
    end

end

-- MENU STATE ^



-- GAME STATE

function updateGame()
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


function drawGame()
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

function gameInit()
    music(-1)
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

   dCam()

end


-- GAME STATE ^


-- GAMEOVER STATE

    function gameoverDraw()
        cls()
        print("YOU LOST", player.x, player.y - 20)
        print("you scored: " .. score, player.x - 20, player.y + 20)
        
        if flr(time() * 2) % 2 == 0 then
        print("PRESS x TO RESTART", player.x - 20, player.y + 40)
        end

        print()
        displayHealth()
        Explosion:draw()
    end



    function gameoverUpdate()
        Explosion:update()

        if btn(5) then
            updateFn = updateGame
            drawFn = drawGame
            gameInit()
        end
    end

    function gameoverInit()

        gameoverSfx = 10
        music(-1)
        music(gameoverSfx)

    end



-- GAMEOVER STATE^





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

        for i = 1, health do
        spr(heartSprite, cx + 2 + (i - 1) * 9, cy + 2)
        end
end





function _init()
    maxWidth = 1024
    maxHeight = 512
    cls()
    srand(time)
    player = {}
    enemy = {}
    setmetatable(enemy, {__index = Enemy})
    setmetatable(player, {__index = Player})
    player:init()
    Enemy:init()
    music(0, 0)

    sfxDisparo = 20
    sfxChoque =  21

    cx = 0
    cy = 0


end





function _update()
    player:update()
    Enemy:update()

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

     for b in all(Bullets) do
        b:draw()
    end

   --print("velocidad X: " .. player.velocidadX, cx, cy, 7)
   --print("velocidad Y: " .. player.velocidadY,  cx, cy + 10, 7)




end


function dCam()
    cx = player.x + 8 - 63
    cy = player.y + 8 - 63
    camera(cx, cy)
end
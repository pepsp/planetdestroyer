Player = {}
Bullets = {}


function Player:init()
    self.x = 63
    self.y = 63
    self.anguloRotacion = 0
    self.spriteNum = 1
    self.velocRotacion = 15
    self.tileSize = 8

    --fisica
    self.velocidadX = 0
    self.velocidadY = 0
    self.aceleracion = 0.1
    self.friccion = .96
    self.velocidadMax = 3
    self.friccionMin = .05
    
    --disparo
    self.cooldown = 0
    self.maxCooldown = 10
    
end

function Player:update()
    self:movement()
    self:colisionMapa()
end

function Player:draw()
    self:rotarSprite(self.spriteNum, self.x, self.y, self.anguloRotacion, 1, 1)
end

function Player:movement()

    self:cooldownReset()
    if btn(0) then self.anguloRotacion -= self.velocRotacion end
    if btn(1) then self.anguloRotacion += self.velocRotacion end

    if btn(4) and self.cooldown == 0 then
        self:shoot()
        self.cooldown = self.maxCooldown

    end

    --acelerar
    if btn(2) then
    self:acelerar()
    
    else
    self.velocidadX *= self.friccion
    self.velocidadY *= self.friccion
    end

    self.x += self.velocidadY
    self.y += self.velocidadX


    self.anguloRotacion = self.anguloRotacion % 360
end


function Player:rotarSprite(spriteNum, posX, posY, angulo, anchoTiles, altoTiles)
    local anchoPx = (anchoTiles or 1) * self.tileSize
    local altoPx  = (altoTiles  or 1) * self.tileSize

    -- origen en la hoja de sprites
    local spriteX = (spriteNum % 8) * self.tileSize
    local spriteY = flr(spriteNum / 8) * self.tileSize

    -- centro del sprite
    local centroX = flr(anchoPx * 0.5)
    local centroY = flr(altoPx * 0.5)

    -- pasar grados a vueltas
    local anguloVueltas = (angulo) / 360
    local senA = sin(anguloVueltas)
    local cosA = cos(anguloVueltas)

    -- dibujar pixel por pixel
    for destinoX = 0, anchoPx - 1 do
        for destinoY = 0, altoPx - 1 do
            local dx = destinoX - centroX
            local dy = destinoY - centroY

            -- aplicar rotación inversa para saber qué pixel original usar
            local srcX = flr(dx * cosA - dy * senA + centroX)
            local srcY = flr(dx * senA + dy * cosA + centroY)

            -- comprobar límites
            if srcX >= 0 and srcX < anchoPx and srcY >= 0 and srcY < altoPx then
                local color = sget(spriteX + srcX, spriteY + srcY)
                pset(posX + destinoX - centroX, posY + destinoY - centroY, color)
            end
        end
    end
end

function Player:shoot()
    sfx(sfxDisparo)
    local b = Bullet:new(self.x, self.y, self.anguloRotacion)
    b.dx += self.velocidadY
    b.dy += self.velocidadX

    add(Bullets, b)
end


function Player:acelerar()
    local anguloVueltas = self.anguloRotacion / 360
    local dx = cos(anguloVueltas)
    local dy = sin(anguloVueltas)

    self.velocidadX += dx * self.aceleracion
    self.velocidadY += dy * self.aceleracion

     
        -- limitar velocidad
    if abs(self.velocidadX) < self.friccionMin then
            self.velocidadX = 0
        end
    if abs(self.velocidadY) < self.friccionMin then
            self.velocidadY = 0
        end

    -- limitar velocidad X
    if self.velocidadX > self.velocidadMax then
    self.velocidadX = self.velocidadMax
    elseif self.velocidadX < -self.velocidadMax then
    self.velocidadX = -self.velocidadMax
    end

-- limitar velocidad Y
    if self.velocidadY > self.velocidadMax then
    self.velocidadY = self.velocidadMax
    elseif self.velocidadY < -self.velocidadMax then
    self.velocidadY = -self.velocidadMax
    end
    end





function Player:colisionMapa()
     

    if self.x < 0 then
        sfx(sfxChoque)
        self.x = 0
        self.velocidadY = -self.velocidadY
        
    elseif self.x >  maxWidth then
        sfx(sfxChoque)
        self.x = maxWidth
        self.velocidadY = -self.velocidadY
        
    end

    if self.y < 0 then
        sfx(sfxChoque)
        self.y = 0
        self.velocidadX = -self.velocidadX
        
    elseif self.y > maxHeight then
        sfx(sfxChoque)
        self.y = maxHeight 
        self.velocidadX = -self.velocidadX
        
    end
end



function Player:cooldownReset()

    if self.cooldown > 0 then
        self.cooldown -= 1

    end
end

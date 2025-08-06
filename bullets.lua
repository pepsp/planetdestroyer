Bullet = {}
Bullet.__index = Bullet

velocidadBala = 6



function Bullet:new(x, y, angulo)
    local ang = (angulo+90) / 360
    local dx = cos(ang) 
    local dy = -sin(ang)

    local o = {
        x = x,
        y = y,
        dx = dx * velocidadBala,
        dy = dy * velocidadBala,
        radio = 1,
        live = true,
        liveTimer = 13
    }
    setmetatable(o, Bullet)
    return o

end

function Bullet:update()
    self.x += self.dx
    self.y += self.dy
    
    self.liveTimer -= 1

    if self.liveTimer <= 0 then
        self.live = false
    end

end

function Bullet:draw()
        pset(self.x, self.y,11)
end

-- brick.lua

local Brick = {}
Brick.__index = Brick

function Brick.new(x, y, width, height, strength)
    local self = setmetatable({}, Brick)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.strength = strength or 1
    self.alive = true
    return self
end

function Brick:hit(damage)
    self.strength = self.strength - (damage or 1)
    if self.strength <= 0 then
        self.alive = false
    end
end

function Brick:draw()
    if self.alive then
        -- Color varies based on strength
        local colorValue = math.max(0.2, self.strength * 0.2)
        love.graphics.setColor(1, colorValue, colorValue)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1)  -- reset color
    end
end

return Brick

-- ball.lua

local Ball = {}
Ball.__index = Ball

function Ball.new(x, y, power)
    local self = setmetatable({}, Ball)
    self.radius = 10
    self.x = x
    self.y = y
    self.speed = 250
    self.dx = 0
    self.dy = 0
    self.launched = false
    self.power = power or 1
    return self
end

function Ball:reset(paddle)
    self.launched = false
    self.dx = 0
    self.dy = 0
    self.x = paddle.x + paddle.width / 2
    self.y = paddle.y - self.radius
end

function Ball:launch()
    self.dx = self.speed
    self.dy = -self.speed
    self.launched = true
end

function Ball:update(dt, paddle, bricks)
    if not self.launched then
        self.x = paddle.x + paddle.width / 2
        self.y = paddle.y - self.radius
    else
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt

        -- Wall collision
        if self.x - self.radius < 0 then
            self.x = self.radius
            self.dx = -self.dx
        elseif self.x + self.radius > love.graphics.getWidth() then
            self.x = love.graphics.getWidth() - self.radius
            self.dx = -self.dx
        end

        if self.y - self.radius < 0 then
            self.y = self.radius
            self.dy = -self.dy
        end

        -- Paddle
        self:handleCollide(paddle)

        -- Bricks
        for _, brick in ipairs(bricks) do
            if brick.alive then
                self:handleCollide(brick)
            end
        end

        if self.y - self.radius > love.graphics.getHeight() then
            self:reset(paddle)
        end
    end
end

function Ball:handleCollide(obj)
    local ballBottom = self.y + self.radius
    local ballTop = self.y - self.radius
    local ballLeft = self.x - self.radius
    local ballRight = self.x + self.radius

    local objTop = obj.y
    local objBottom = obj.y + obj.height
    local objLeft = obj.x
    local objRight = obj.x + obj.width

    if ballBottom >= objTop and ballTop <= objBottom and
       ballRight >= objLeft and ballLeft <= objRight then

        local fromTop = ballBottom - objTop
        local fromBottom = objBottom - ballTop
        local fromLeft = ballRight - objLeft
        local fromRight = objRight - ballLeft

        local minOverlap = math.min(fromTop, fromBottom, fromLeft, fromRight)

        if minOverlap == fromTop then
            self.dy = -math.abs(self.dy)
            self.y = objTop - self.radius
        elseif minOverlap == fromBottom then
            self.dy = math.abs(self.dy)
            self.y = objBottom + self.radius
        elseif minOverlap == fromLeft then
            self.dx = -math.abs(self.dx)
            self.x = objLeft - self.radius
        elseif minOverlap == fromRight then
            self.dx = math.abs(self.dx)
            self.x = objRight + self.radius
        end

        if obj.hit then
            obj:hit(self.power)
        end
    end
end

function Ball:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Ball

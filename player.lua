-- player.lua

local Player = {}
Player.__index = Player

function Player.new()
    local self = setmetatable({}, Player)
    self.paddle = {
        width = 100,
        height = 20,
        x = (love.graphics.getWidth() - 100) / 2,
        y = love.graphics.getHeight() - 40,
        speed = 300
    }

    self.balls = {}
    self.ballUpgrades = {}
    self.paddleUpgrades = {}
    return self
end

function Player:update(dt)
    if love.keyboard.isDown("right") then
        self.paddle.x = math.min(self.paddle.x + self.paddle.speed * dt, love.graphics.getWidth() - self.paddle.width)
    elseif love.keyboard.isDown("left") then
        self.paddle.x = math.max(self.paddle.x - self.paddle.speed * dt, 0)
    end

    for _, ball in ipairs(self.balls) do
        ball:update(dt, self.paddle, self.bricks or {})
    end
end

function Player:draw()
    love.graphics.rectangle("fill", self.paddle.x, self.paddle.y, self.paddle.width, self.paddle.height)
    for _, ball in ipairs(self.balls) do
        ball:draw()
    end
end

function Player:addBall(ball)
    table.insert(self.balls, ball)
end

function Player:setBricks(bricks)
    self.bricks = bricks
end

function Player:launchBalls()
    for _, ball in ipairs(self.balls) do
        if not ball.launched then
            ball:launch()
        end
    end
end

return Player

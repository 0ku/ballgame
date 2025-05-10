-- level.lua
local Brick = require("brick")
local Level = {}
Level.__index = Level

function Level.new(rows, cols)
    local self = setmetatable({}, Level)
    self.bricks = {}
    self.rows = rows or 5
    self.cols = cols or 10
    self.brickWidth = 60
    self.brickHeight = 20
    self.padding = 10
    self.offsetTop = 50
    self.offsetLeft = 35

    self:generate()
    return self
end

function Level:generate()
    -- for row = 1, self.rows do
    --     for col = 1, self.cols do
    --         if love.math.random() < 0.6 then
    --             local x = self.offsetLeft + (col - 1) * (self.brickWidth + self.padding)
    --             local y = self.offsetTop + (row - 1) * (self.brickHeight + self.padding)
    --             local strength = love.math.random(1, 3) -- random strength between 1 and 3
    --             local brick = Brick.new(x, y, self.brickWidth, self.brickHeight, strength)
    --             table.insert(self.bricks, brick)
    --         end
    --     end
    -- end

    local strength = love.math.random(1, 1) -- random strength between 1 and 3
    local brick = Brick.new(500, 500, self.brickWidth, self.brickHeight, strength)
    table.insert(self.bricks, brick)
end

function Level:draw()
    for _, brick in ipairs(self.bricks) do
        brick:draw()
    end
end

function Level:getBricks()
    return self.bricks
end

function Level:isCleared()
    return #self.bricks == 0
end

return Level

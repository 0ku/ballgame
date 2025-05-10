local Player = require("player")
local Ball = require("ball")
local Level = require("level")

local game = {}

game.state = "menu"
game.player = Player.new()
game.ball = Ball.new(0, 0, 1)
game.level = Level.new()
game.hoveredButton = nil

function game.load()
    love.graphics.setFont(love.graphics.newFont(24))
end

function game.keypressed(key)
    if key == "space" and game.state == "play" and not game.ball.launched then
        game.ball:launch()
    end
end

function game.mousepressed(x, y, button)
    if button == 1 then
        if game.state == "menu" and game.hoveredButton == "play" then
            game.state = "play"
        elseif game.state == "win" and game.hoveredButton == "menu" then
            game.state = "menu"
        end
    end
end

-- Update hover state based on mouse position
function game.updateHoverState()
    local mx, my = love.mouse.getX(), love.mouse.getY()
    game.hoveredButton = nil

    if game.state == "menu" then
        if mx > 350 and mx < 450 and my > 300 and my < 340 then
            game.hoveredButton = "play"
        end
    elseif game.state == "win" then
        if mx > 300 and mx < 500 and my > 350 and my < 390 then
            game.hoveredButton = "menu"
        end
    end
end

function game.update(dt)
    -- Update hover state for button detection
    game.updateHoverState()

    if game.state == "play" then
        game.player:update(dt)
        game.ball:update(dt, game.player.paddle, game.level.bricks)

        -- Check if all bricks are cleared
        if game.level:isCleared() then
            game.state = "win"
        end
    end
end

function game.draw()
    if game.state == "menu" then
        game.drawMenu()
    elseif game.state == "play" then
        game.drawGame()
    elseif game.state == "win" then
        game.drawWinScreen()
    end
end

function game.drawMenu()
    love.graphics.printf("BrickRooms", 0, 100, love.graphics.getWidth(), "center")
    local x, y, w, h = 350, 300, 100, 40
    if game.hoveredButton == "play" then
        love.graphics.setColor(0.8, 0.8, 1)
    else
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.rectangle("line", x, y, w, h)
    love.graphics.printf("Play", x, y + 10, w, "center")
end

function game.drawGame()
    game.player:draw()
    game.ball:draw()
    game.level:draw()
end

function game.drawWinScreen()
    love.graphics.printf("You Win!", 0, 150, love.graphics.getWidth(), "center")
end

return game

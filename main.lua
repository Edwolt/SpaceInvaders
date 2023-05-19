local Game = require'Game'
local Vec = require'modules.Vec'
local inspect = require'modules.inspect'

local game
local pause = false

function love.load()
    game = Game()
    love.window.setTitle'Space Invaders'
    love.window.setMode(400, 600, {
        msaa = 0,
        resizable = false,
        borderless = true,
    })
end

function love.draw()
    local a = Vec(0, 1)
    local b = Vec(2, 0)
    game:draw()
end

function love.update(dt)
    if pause then
        return
    end
    game:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        pause = not pause
    elseif key == 'l' then
        love.event.quit(0)
    else
        game:keypressed(key)
    end
end

--[[
function love.load() end
function love.draw() end
function love.update(dt) end

function love.keyreleased(key) end
function love.resize(w, h) end
function love.focus(bool) end
function love.keypressed(key, unicode) end
function love.keyreleased(key, unicode) end
function love.mousepressed(x, y, button) end
function love.mousereleased(x, y, button) end
function love.quit() end
--]]

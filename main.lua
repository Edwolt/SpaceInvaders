inspect = require'utils.inspect'
local Game = require'Game'
local Vec = require'modules.Vec'

local game
local pause = false


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest', 0)

    love.window.setTitle'Space Invaders'
    love.window.setMode(256*2, 240*2, {
        msaa = 0,
        resizable = false,
        borderless = false,
    })

    Game:load()
    game = Game()
end

function love.draw()
    game:draw()

    if pause then
        -- Draw pause Menu
    end
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
    elseif key == 'f' then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
end


function love.resize(w, h)
    game:resize()
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

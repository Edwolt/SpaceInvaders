-- Globals
dbg = require'utils.dbg'
inspect = dbg.inspect
require'SETTINGS'

local Game = require'Game'
local Key = SETTINGS.Key

local game
local pause = false


function love.load()
    dbg.print'Panetone > Chocotone'
    dbg.print(_VERSION)
    dbg.inspect{SETTINGS, 'SETTINGS'}
    dbg.print()

    dbg.log.load'main'
    love.graphics.setDefaultFilter('nearest', 'nearest', 0)

    love.window.setTitle'Space Invaders'
    love.window.setMode(
        256 * 2, 240 * 2,
        {
            msaa = 0,
            resizable = true,
            borderless = false,
        }
    )

    Game:load()
    game = Game()

    dbg.log.loaded'main'
    dbg.print()
end

function love.draw()
    game:draw()
end

function love.update(dt)
    SETTINGS.Key:update(dt)
    game:keydown()
    game:update(dt)
end

function love.keypressed(key)
end

function love.resize(w, h)
    -- SETTINGS.SCALE is now computed
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

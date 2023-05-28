-- Globals
dbg = require'utils.dbg'
inspect = dbg.inspect
require'SETTINGS'

local colors = require'modules.color'
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
    love.graphics.setBackgroundColor(colors.OCEAN)

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
    Key:update(dt)
    game:keydown()
    game:update(dt)
end

local color = require'modules.color'
local Vec = require'modules.Vec'
local Text = require'objects.Text'
local Spaceship = require'objects.Spaceship'

--- Load highscore from the file
local function loadHighscore()
    dbg.log.load'highscore'

    local path = SETTINGS.HIGHSCORE_PATH
    local file = io.open(path, 'r')

    local highscore
    if file ~= nil then
        highscore = file:read'*n'
        print(highscore)
        file:close()
    end

    dbg.log.loadedv('highscore = ', highscore)
    return highscore or 0
end

--- Write Highscore to the file
local function saveHighscore(value)
    dbg.log.save('highscore', value)

    local path = SETTINGS.HIGHSCORE_PATH
    local file = io.open(path, 'w')
    if file ~= nil then
        file:write(value)
        file:close()
    else
        dbg.print'Filed to open highscore file'
    end

    dbg.log.saved'highscore'
end

local SCREEN_BLOCKS = SETTINGS.SCREEN_BLOCKS
local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dbg.log.load'HUD'

        Text:load()
        Spaceship:load()


        dbg.log.loaded'HUD'
    end,
}
M.__index = M

local function new(_)
    local self = {
        highscore = loadHighscore(),
        score = 0,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:draw(spaceship)
    -- It needs the spaceship as parameter to know how many lives to draw
    -- And to hace the sprite for drawing
    love.graphics.setColor(color.WHITE)

    Text:draw(Vec(0, 0), 0.5, string.format('HIGH:  %07d', self.highscore))
    Text:draw(Vec(0, 0.5), 0.5, string.format('SCORE: %07d', self.score))
    for i = 1, spaceship.lifes do
        spaceship:drawInPosition(Vec(SCREEN_BLOCKS.x - i, 0))
    end
end

function M:drawState(state)
    love.graphics.setColor(color.RED)
    local SCREEN_BLOCKS = SETTINGS.SCREEN_BLOCKS

    local text = string.format(
        '%s%s%s%s',
        state.pause and 'P' or '0',
        state.gameOver and 'G' or '0',
        state.debug and 'D' or '0',
        state.fast and 'F' or '0'
    )

    local pos = Vec(0, 0)
    pos.y = 0
    pos.x = SCREEN_BLOCKS.x - 9
    Text:draw(pos, 1, string.format(text))
end

function M:addScore(dscore)
    self.score = self.score + dscore
end

--- Update the Highscore
--- I decided to make highscore only update when the game is finish
---
--- Also saves highscore in file
function M:updateHighscore()
    if self.score > self.highscore then
        self.highscore = self.score
        saveHighscore(self.highscore)
    end
end

return M

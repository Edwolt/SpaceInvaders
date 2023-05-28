local Vec = require'modules.Vec'
local Text = require'objects.Text'
local Spaceship = require'objects.Spaceship'
local color = require'modules.color'

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
    LIFES = {
        Spaceship(Vec(SCREEN_BLOCKS.x - 1, 0)),
        Spaceship(Vec(SCREEN_BLOCKS.x - 2, 0)),
        Spaceship(Vec(SCREEN_BLOCKS.x - 3, 0)),
    },
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
        lifes = 3,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:draw()
    love.graphics.setColor(color.WHITE)

    Text:draw(
        Vec(0, 0), 0.5,
        string.format('HIGH:  %07d', self.highscore * SETTINGS.SCORE_FACTOR)
    )
    Text:draw(
        Vec(0, 0.5), 0.5,
        string.format('SCORE: %07d', self.score * SETTINGS.SCORE_FACTOR)
    )
    for i = 1, self.lifes do
        self.LIFES[i]:draw()
    end
end

function M:drawState(state)
    love.graphics.setColor(color.RED)
    local SCREEN_BLOCKS = SETTINGS.SCREEN_BLOCKS

    local text = ''
    text = text .. (state.pause and 'P' or '0')
    text = text .. (state.gameOver and 'G' or '0')
    text = text .. (state.debug and 'D' or '0')

    local pos = Vec(0, 0)
    pos.y = 0
    pos.x = SCREEN_BLOCKS.x - 2 - #text
    Text:draw(pos, 1, string.format(text))
end

function M:addScore(dscore)
    self.score = self.score + dscore
end

function M:updateHighscore()
    if self.score > self.highscore then
        self.highscore = self.score
        saveHighscore(self.highscore)
    end
end

function M:isSpaceshipAlive()
    return self.lifes >= 0
end

function M:damageSpaceship()
    self.lifes = self.lifes - 1
end

return M

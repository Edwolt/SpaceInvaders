local clone = require'utils.clone'

local Vec = require'modules.Vec'
local Text = require'objects.Text'
local Spaceship = require'objects.Spaceship'


local SCREEN_BLOCKS = SETTINGS.SCREEN_BLOCKS
local M = {
    _loaded = false,
    LIVES = {
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

local function new(_, high_score)
    local self = {
        high_score = high_score or 0,
        score = 0,
        lives = 3,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:draw()
    Text:draw(Vec(0, 0), 1 / 2, string.format('HIGH:  %05d', self.high_score))
    Text:draw(Vec(0, 1), 1 / 2, string.format('SCORE: %05d', self.score))

    for i = 1, self.lives do
        self.LIVES[i]:draw()
    end
end

return M

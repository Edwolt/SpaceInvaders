local clone = require'utils.clone'

local Vec = require'modules.Vec'
local Text = require'objects.Text'

local M = {
    _loaded = false,
}

function M.load(M)
    if not M._loaded then
        M._loaded = true
        Text:load()
    end
end

M.__index = M

local function new(_, high_score)
    local self = {
        high_score = high_score or 0,
        score = 0,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:draw(settings)
    local settings = clone(settings)
    settings.SCALE = settings.SCALE / 2

    Text:draw(Vec(0, 0), string.format('HIGH:  %05d', self.high_score), settings)
    Text:draw(Vec(0, 1), string.format('SCORE: %05d', self.score), settings)
end

return M

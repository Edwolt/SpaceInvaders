local Vec = require'modules.Vec'

local M = {
    _loaded = false,
}

function M.load(M)
end

M.__index = M

local function new(_, pos)
    local self = {
        pos = pos,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:draw(settings)
    local SCALE = settings.SCALE
    local BLOCK_SIZE = settings.BLOCK_SIZE

    local screen_pos = self.pos:toscreen(settings)
    local size = Vec(2, 6)
    size = size * SCALE

    screen_pos.x = screen_pos.x + Vec(0.5, 0):toscreen(settings).x
    screen_pos.x = screen_pos.x - size.x / 2

    love.graphics.rectangle('fill', screen_pos.x, screen_pos.y, size.x, size.y)
end

function M:update(dt, settings)
    local BULLET_VELOCITY = settings.BULLET_VELOCITY
    self.pos.y = self.pos.y - dt * BULLET_VELOCITY
end

return M

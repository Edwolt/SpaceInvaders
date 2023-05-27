local Vec = require'modules.Vec'

local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dgb.log.load'Bullet'

        dgb.log.loaded'Bullet'
    end,
}
M.__index = M

local function new(_, pos)
    local self = {
        pos = pos,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:draw()
    local SCALE = SETTINGS.SCALE()
    local BLOCK_SIZE = SETTINGS.BLOCK_SIZE

    local screen_pos = self.pos:toscreen()
    local size = Vec(2, 6)
    size = size * SCALE

    screen_pos.x = screen_pos.x + Vec(0.5, 0):toscreen().x
    screen_pos.x = screen_pos.x - size.x / 2

    love.graphics.rectangle('fill', screen_pos.x, screen_pos.y, size.x, size.y)
end

function M:update(dt)
    local BULLET_VELOCITY = SETTINGS.BULLET_VELOCITY
    self.pos.y = self.pos.y - dt * BULLET_VELOCITY
end

return M

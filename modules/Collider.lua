local Vec = require'modules.Vec'

local M = {}
M.__index = M

local function new(_, pos, size)
    local self = {
        pos = pos,
        size = size,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M.collision(a, b)
    local a1, a2 = a.pos, a.pos + a.size
    local b1, b2 = b.pos, b.pos + b.size

    local on_x = a1.x < b2.x and a2.x > b1.x
    local on_y = a1.y < b2.y and a2.y > b2.y
    return on_x and on_y
end

function M:draw(color)
    love.graphics.setColor(color)

    local screen_pos = self.pos:toscreen()
    local screen_size = self.size:toscreen()

    love.graphics.rectangle(
        'line',
        screen_pos.x, screen_pos.y,
        screen_size.x, screen_size.y
    )
end

return M

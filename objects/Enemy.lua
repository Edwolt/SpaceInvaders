local Vec = require'modules.Vec'
local inspect = require'modules.inspect'

local M = {
    load = function(M)
        M.sprite = love.graphics.newImage'images/enemy.png'
        M.tam = Vec(M.sprite:getWidth(), M.sprite:getHeight())
    end,
}
M.__index = M

local function new(_, pos)
    local self = {
        pos = pos or Vec(),
    }
    return setmetatable(self, M)
end
setmetatable(M, {__call = new})


function M:draw(opts)
    local scale = opts.scale or 1
    local screen_pos = self.pos * opts.scale
    love.graphics.draw(
        self.sprite,
        screen_pos.x, screen_pos.y, 0,
        scale.x, scale.y
    )
end

function M:update(opts)
    inspect{opts, 'opts'}
    local direction = opts.direction

    local dpos
    if direction == 'right' then
        dpos = Vec(1, 0)
    elseif direction == 'left' then
        dpos = Vec( -1, 0)
    elseif direction == 'up' then
        dpos = Vec(0, 1)
    elseif direction == 'down' then
        dpos = Vec(0, -1)
    else
        error('Invalid direction: ' .. direction)
    end
    dpos = dpos * self.tam

    self.pos = self.pos + dpos
end

function M:move(vel)
    self.vel = vel
end

function M:getCollider()

end

return M

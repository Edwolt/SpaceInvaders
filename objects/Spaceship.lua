local Vec = require'modules.Vec'
local inspect = require'modules.inspect'

local M = {
    load = function(M)
        M.sprite = love.graphics.newImage'images/spaceship.png'
        M.tam = Vec(M.sprite:getWidth(), M.sprite:getHeight())
    end,
}
M.__index = M

local function new(_, pos)
    local self = {
        pos = pos or Vec(),
        vel = Vec(0, 0),
    }
    return setmetatable(self, M)
end
setmetatable(M, {__call = new})


function M:draw(opts)
    local scale = opts.scale or 1
    local screen_pos = scale * self.pos
    love.graphics.draw(
        self.sprite,
        screen_pos.x, screen_pos.y, 0,
        scale.x, scale.y
    )
end

function M:update(opts)
    local dt = opts[1]
    local VELOCITY = opts.VELOCITY or 1

    self.pos = self.pos + (dt * VELOCITY * self.vel)
end

function M:move(vel)
    self.vel = vel
end

function M:getCollider()

end

return M

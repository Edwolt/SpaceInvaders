local Vec = require'modules.Vec'
local inspect = require'modules.inspect'

local M = {
    sprite = love.graphics.newImage'images/spaceship.png'
}
M.tam = Vec(M.sprite:getWidth(), M.sprite:getHeight())
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
    love.graphics.draw(self.sprite, self.pos.x, self.pos.y, 0, scale, scale)
end

function M:update(opts)
    local dt = opts[1]
    local VELOCITY = opts.VELOCITY or 1
    inspect(VELOCITY, 'velocity')

    self.pos = self.pos + (dt * VELOCITY * self.vel)
end

function M:move(vel)
    self.vel = vel
end

function M:getCollider()

end

return M

local Vec = require'modules.Vec'
local Spaceship = require'objects.Spaceship'
local inspect = require'modules.inspect'

local M = {
    paused = false,
    SCALE = 2,
    SPACESHIP_VELOCITY = 50,
}
M.__index = M

local function new(_)
    local self = {
        spaceship = Spaceship(Vec(10, 10)),
    }
    return setmetatable(self, M)
end
setmetatable(M, {__call = new})

function M:draw()
    self.spaceship:draw{scale = self.SCALE, velocity = self.spaceship_velocity}
end

function M:update(dt)
    if self.paused then
        return
    end

    self.spaceship:update{dt, VELOCITY = self.SPACESHIP_VELOCITY}
end

function M:keypressed(key)
    local move = Vec(0, 0)
    if key == 'right' or key == 'd' then
        move = move + Vec(1, 0)
    elseif key == 'left' or key == 'a' then
        move = move + Vec( -1, 0)
    elseif key == 'up' or key == 'w' then
        move = move + Vec(0, -1)
    elseif key == 'down' or key == 's' then
        move = move + Vec(0, 1)
    end
    move = move:versor()

    self.spaceship:move(move)
end

return M

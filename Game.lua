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

    local keyIsDown = love.keyboard.isDown

    -- Update spaceship movement direction
    local dir = Vec(0, 0)
    if keyIsDown'right' or keyIsDown'd' then
        dir = dir + Vec(1, 0)
    elseif keyIsDown'left' or keyIsDown'a' then
        dir = dir + Vec( -1, 0)
    elseif keyIsDown'up' or keyIsDown'w' then
        dir = dir + Vec(0, -1)
    elseif keyIsDown'down' or keyIsDown's' then
        dir = dir + Vec(0, 1)
    end
    self.spaceship:move(dir:versor())

    -- Updating spaceship
    self.spaceship:update{dt, VELOCITY = self.SPACESHIP_VELOCITY}
end

return M

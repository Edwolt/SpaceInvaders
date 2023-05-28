local clone = require'utils.clone'
local color = require'modules.color'
local Vec = require'modules.Vec'
local Collider = require'modules.Collider'

local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dbg.log.load'Bullet'

        M.SIZE = Vec(2, 6) / SETTINGS.BLOCK_SIZE

        dbg.log.loaded'Bullet'
    end,
}
M.__index = M

local function new(M, pos, vel)
    pos = clone(pos)
    pos.x = pos.x + 0.5
    pos.x = pos.x - (M.SIZE.x / SETTINGS.BLOCK_SIZE.x) / 2

    local self = {
        pos = pos,
        vel = vel or SETTINGS.BULLET_VELOCITY,
        health = 1, -- The health of the bullet is how much damage it causes
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:draw()
    if not self:isAlive() then
        return
    end

    love.graphics.setColor(color.WHITE)

    local screen_size = self.SIZE:toscreen()
    local screen_pos = self.pos:toscreen()
    love.graphics.rectangle(
        'fill',
        screen_pos.x, screen_pos.y,
        screen_size.x, screen_size.y
    )
end

function M:update(dt)
    self.pos = self.pos + dt * self.vel
end

function M:damage()
    self.health = self.health - 1
end

function M:isAlive()
    return self.health > 0
end

function M:collider()
    return Collider(self.pos, self.SIZE)
end

return M

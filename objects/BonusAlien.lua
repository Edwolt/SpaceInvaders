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
        dbg.log.load'Bonus Alien'

        M.SPRITE = love.graphics.newImage'assets/bonus.png'
        M._size = Vec(16, 16)

        dbg.log.loaded'Bonus Alien'
    end,
}
M.__index = M

local function new(_, pos, vel)
    local self = {
        pos = pos,
        vel = vel,
        health = 1,
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

    local SCALE = SETTINGS.SCALE()
    local screen_pos = self.pos:toscreen()
    love.graphics.draw(
        self.SPRITE,
        screen_pos.x, screen_pos.y, 0,
        SCALE.x, SCALE.y
    )
end

function M:update(dt)
    self.pos = self.pos + dt * self.vel
end

function M:collider()
    return Collider(self.pos, self:size())
end

function M:size()
    local BLOCK_SIZE = SETTINGS.BLOCK_SIZE
    return self._size / BLOCK_SIZE
end

function M:damage()
    if not self:isAlive() then
        return 0
    end

    self.health = self.health - 1
    if self.health <= 0 then
        return self:killScore()
    end
    return 0
end

function M:isAlive()
    return self.health > 0
end

--- Returns the score for killing this alien
function M:killScore()
    return SETTINGS.BONUS_ALIEN_SCORE
end

return M

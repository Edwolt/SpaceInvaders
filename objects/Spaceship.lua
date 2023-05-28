local clamp = require'utils.clamp'
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
        dbg.log.load'Spaceship'

        M.SPRITE = love.graphics.newImage'assets/spaceship.png'
        dbg.log.loaded'Spaceship'
    end,
}
M.__index = M


local function new(_, pos)
    local self = {
        pos = pos,
        vel = Vec(0, 0),
        lifes = 3,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})


function M:draw()
    self:drawInPosition(self.pos)
end

--- Draw the spaceship in a given position
--- Differently from the draw method that draw where the spaceship is
function M:drawInPosition(pos)
    love.graphics.setColor(color.WHITE)

    local SCALE = SETTINGS.SCALE()
    local screen_pos = pos:toscreen()
    love.graphics.draw(
        self.SPRITE,
        screen_pos.x, screen_pos.y, 0,
        SCALE.x, SCALE.y
    )
end

function M:update(dt)
    local SCREEN_BLOCKS = SETTINGS.SCREEN_BLOCKS
    local VELOCITY = SETTINGS.SPACESHIP_VELOCITY

    self.pos = self.pos + (dt * VELOCITY * self.vel)
    self.pos.x = clamp(0, self.pos.x, SCREEN_BLOCKS.x - self:size().x)
end

function M:collider()
    return Collider(self.pos, self:size())
end

function M:size()
    local BLOCK_SIZE = SETTINGS.BLOCK_SIZE
    return Vec.imageSize(self.SPRITE) / BLOCK_SIZE
end

--- Set the velocity of the spaceship
--- Can be used to set the direction of the spaceship
function M:move(vel)
    self.vel = vel
end

function M:isAlive()
    return self.lifes >= 0
end

function M:damage()
    self.lifes = self.lifes - 1
end

return M

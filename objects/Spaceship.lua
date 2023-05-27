local clamp = require'utils.clamp'

local Vec = require'modules.Vec'

local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dbg.log.load'Spaceship'

        M.sprite = love.graphics.newImage'assets/spaceship.png'
        dbg.log.loaded'Spaceship'
    end,
}
M.__index = M


local function new(_, pos)
    local self = {
        pos = pos,
        vel = Vec(0, 0),
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})


function M:draw()
    local SCALE = SETTINGS.SCALE()
    local screen_pos = self.pos:toscreen()
    love.graphics.draw(
        self.sprite,
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

function M:size()
    local BLOCK_SIZE = SETTINGS.BLOCK_SIZE
    return Vec.image_size(self.sprite) / BLOCK_SIZE
end

function M:move(vel)
    self.vel = vel
end

function M:getCollider()

end

return M

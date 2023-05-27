local clamp = require'utils.clamp'

local Vec = require'modules.Vec'

local M = {_loaded = false}

function M.load(M)
    if not M._loaded then
        M._loaded = true
        M.sprite = love.graphics.newImage'images/spaceship.png'
    end
end

M.__index = M


local function new(_, pos)
    local self = {
        pos = pos or Vec(),
        vel = Vec(0, 0),
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})


function M:draw(settings)
    local SCALE = settings.SCALE
    local screen_pos = self.pos:toscreen(settings)
    love.graphics.draw(
        self.sprite,
        screen_pos.x, screen_pos.y, 0,
        SCALE.x, SCALE.y
    )
end

function M:update(dt, settings)
    local BLOCK_NUMBER = settings.BLOCK_NUMBER
    local VELOCITY = settings.SPACESHIP_VELOCITY
    self.pos = self.pos + (dt * VELOCITY * self.vel)

    self.pos.x = clamp(0, self.pos.x, BLOCK_NUMBER.x - self:size(settings).x)
end

function M:size(settings)
    local BLOCK_SIZE = settings.BLOCK_SIZE
    return Vec.image_size(self.sprite) / BLOCK_SIZE
end

function M:move(vel)
    self.vel = vel
end

function M:getCollider()

end

return M

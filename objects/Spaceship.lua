local Vec = require'modules.Vec'
local inspect = require'modules.inspect'

local M = {}

function M.load(M)
    M.sprite = love.graphics.newImage'images/spaceship.png'
end

M.__index = M


local function new(_, pos)
    local self = {
        pos = pos or Vec(),
        vel = Vec(0, 0),
    }
    return setmetatable(self, M)
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
    local VELOCITY = settings.SPACESHIP_VELOCITY
    self.pos = self.pos + (dt * VELOCITY * self.vel)

    if self.pos.x < 0 then
        self.pos.x = 0
    end
    if self.pos.x > settings.BLOCK_NUMBER.x - self:size(settings).x then
        self.pos.x = settings.BLOCK_NUMBER.x - self:size(settings).x
    end
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

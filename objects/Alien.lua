local Vec = require'modules.Vec'

local M = {_loaded = false}

function M.load(M)
    if not M._loaded then
        M._loaded = true
        M.sprite = love.graphics.newImage'images/enemy.png'
    end
end

M.__index = M

local function new(_, pos)
    local self = {
        pos = pos or Vec(),
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})


function M:draw(settings)
    local SCALE = settings.SCALE or 1
    local screen_pos = self.pos:toscreen(settings)
    love.graphics.draw(
        self.sprite,
        screen_pos.x, screen_pos.y, 0,
        SCALE.x, SCALE.y
    )
end

function M:update(direction, settings)
    local dpos
    if direction == 'right' then
        dpos = Vec(1, 0)
    elseif direction == 'left' then
        dpos = Vec( -1, 0)
    elseif direction == 'up' then
        dpos = Vec(0, -1)
    elseif direction == 'down' then
        dpos = Vec(0, 1)
    else
        error('Invalid direction: ' .. tostring(direction))
    end
    dpos = dpos * self:size(settings)

    self.pos = self.pos + dpos
end

function M:size(settings)
    local BLOCK_SIZE = settings.BLOCK_SIZE
    return Vec.image_size(self.sprite) / BLOCK_SIZE
end

function M:getCollider()

end

return M

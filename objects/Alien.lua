local Vec = require'modules.Vec'

local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dbg.log.load'Alien'

        M.sprite = love.graphics.newImage'assets/enemy.png'

        dbg.log.loaded'Alien'
    end,
}
M.__index = M

local function new(_, pos)
    local self = {
        pos = pos,
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

function M:update(direction)
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
    dpos = dpos * self:size()

    self.pos = self.pos + dpos
end

function M:size()
    local BLOCK_SIZE = SETTINGS.BLOCK_SIZE
    return Vec.image_size(self.sprite) / BLOCK_SIZE
end

function M:getCollider()

end

return M

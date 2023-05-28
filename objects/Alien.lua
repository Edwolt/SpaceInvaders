local color = require'modules.color'
local Vec = require'modules.Vec'
local Collider = require'modules.Collider'
local quads = require'modules.quads'

local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dbg.log.load'Alien'

        M.SPRITE = love.graphics.newImage'assets/enemy.png'

        M._size = Vec(16, 16)
        M.QUADS = quads(2, M._size)
        dbg.log.loaded'Alien'
    end,
}
M.__index = M

local function new(_, opts)
    local pos = opts[1]
    local health = opts.health

    local self = {
        pos = pos,
        health = health,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})


function M:draw(frame)
    if not self:isAlive() then
        return
    end

    love.graphics.setColor(color.WHITE)

    local SCALE = SETTINGS.SCALE()
    local screen_pos = self.pos:toscreen()
    love.graphics.draw(
        self.SPRITE, self.QUADS[frame % 2 + 1],
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

-- Aliens more away from the bottom, gives more score
function M:killScore()
    local ALIEN_ROW_SCORE = SETTINGS.ALIEN_ROW_SCORE
    return SETTINGS.ALIEN_ROW_SCORE(self.pos.y)
end

function M:reachBottomRow()
    local SCREEN_BLOCKS = SETTINGS.SCREEN_BLOCKS
    local pos = self.pos + self:size()
    if pos.y >= SCREEN_BLOCKS.y - 1 then
        return true
    end
    return false
end

return M

local color = require'modules.color'
local quads = require'modules.quads'
local Vec = require'modules.Vec'
local Collider = require'modules.Collider'

local Bullet = require'objects.Bullet'

local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dbg.log.load'Alien'

        M.SPRITE = love.graphics.newImage'assets/enemy.png'
        M.SPRITE2 = love.graphics.newImage'assets/enemy2.png'
        M.SPRITE2X = love.graphics.newImage'assets/enemy2x.png'
        M.SPRITE3 = love.graphics.newImage'assets/enemy3.png'

        M._size = Vec(16, 16)
        M.QUADS = quads(2, M._size)
        dbg.log.loaded'Alien'
    end,
}
M.__index = M

local function new(_, type, pos)
    local health
    if type == 1 then
        health = 1
    elseif type == 2 then
        health = 2
    elseif type == 3 then
        health = 1
    else
        error('Invalid type: ' .. type)
    end

    local self = {
        type = type,
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
    local sprite
    if self.type == 1 then
        sprite = self.SPRITE
    elseif self.type == 2 then
        if self.health == 2 then
            sprite = self.SPRITE2
        else -- health == 1
            sprite = self.SPRITE2X
        end
    elseif self.type == 3 then
        sprite = self.SPRITE3
    else
        error('Invalid type: ' .. self.type)
    end

    local SCALE = SETTINGS.SCALE()
    local screen_pos = self.pos:toscreen()

    love.graphics.draw(
        sprite, self.QUADS[frame % 2 + 1],
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
    if self.type == 1 then
        return SETTINGS.ALIEN_ROW_SCORE(self.pos.y)
    else
        return SETTINGS.ALIEN_ROW_SCORE(self.pos.y) + 50
    end
end

function M:reachBottomRow()
    local SCREEN_BLOCKS = SETTINGS.SCREEN_BLOCKS
    local pos = self.pos + self:size()
    if pos.y >= SCREEN_BLOCKS.y - 1 then
        return true
    end
    return false
end

function M:shoot(target)
    local BULLET_VELOCITY = SETTINGS.BULLET_VELOCITY

    if self.type == 3 then
        return Bullet(
            self.pos,
            BULLET_VELOCITY:norm() * (target - self.pos):versor()
        )
    end

    return Bullet(self.pos, -BULLET_VELOCITY)
end

return M

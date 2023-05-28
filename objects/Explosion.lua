local color = require'modules.color'
local quads = require'modules.quads'
local timer = require'modules.timer'
local Vec = require'modules.Vec'
local Collider = require'modules.Collider'

local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dbg.log.load'Explosion'

        M.SPRITE = love.graphics.newImage'assets/explosion.png'

        M._size = Vec(16, 16)
        M.QUADS = quads(2, M._size)
        dbg.log.loaded'Explosion'
    end,
}
M.__index = M

local function new(_, pos)
    local self = {
        pos = pos,
        timer = timer.Timer(0.2),
        frame = 0,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})


function M:draw(dt)
    if self.frame >= #self.QUADS then
        return
    end

    love.graphics.setColor(color.WHITE)
    local SCALE = SETTINGS.SCALE()
    local screen_pos = self.pos:toscreen()

    love.graphics.draw(
        self.SPRITE, self.QUADS[self.frame % 2 + 1],
        screen_pos.x, screen_pos.y, 0,
        SCALE.x, SCALE.y
    )
end

function M:update(dt)
    self.timer:update(dt)
    self.timer:clock(function()
        self.frame = self.frame + 1
    end)
end

function M:size()
    local BLOCK_SIZE = SETTINGS.BLOCK_SIZE
    return self._size / BLOCK_SIZE
end

function M:collider()
    return Collider(self.pos, self:size())
end

return M

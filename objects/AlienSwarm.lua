--- Manage a block of aliens

local timer = require'modules.timer'
local Vec = require'modules.Vec'
local Alien = require'objects.Alien'

local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dbg.log.load'AlienSwarm'

        Alien:load()

        dbg.log.loaded'AlienSwarm'
    end,
}
M.__index = M

--- The type and size of the swarm varies from level
---
--- timing is the interval between movements
local function new(_, level, timing)
    local LEVEL_SWARM_ROWS = SETTINGS.LEVEL_SWARM_ROWS
    local row = LEVEL_SWARM_ROWS[level]

    local m = SETTINGS.SWARM_SIZE.numColumns
    local d = SETTINGS.SWARM_SIZE.numMovements
    local n = #row

    local aliens = {}
    for i = 1, n do
        for j = 1, m do
            local pos = Vec(1.5 * j - 1, 1.5 * i + 1)
            aliens[#aliens + 1] = Alien(row[i], pos)
        end
    end

    local movements = {}
    for _ = 1, d do
        movements[#movements + 1] = 'right'
    end
    movements[#movements + 1] = 'down'
    for _ = 1, d do
        movements[#movements + 1] = 'left'
    end
    movements[#movements + 1] = 'down'

    local self = {
        aliens = aliens,
        movements = movements,
        currentMove = 0,
        timer = timer.Timer(timing),
        frame = 0,
        frameTimer = timer.Timer(1),
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:draw()
    for _, alien in ipairs(self.aliens) do
        alien:draw(self.frame)
    end
end

function M:update(dt)
    self.frameTimer:update(dt)
    self.frameTimer:clock(function()
        self.frame = self.frame + 1
    end)

    self.timer:update(dt)
    self.timer:clock(function()
        for _, alien in ipairs(self.aliens) do
            alien:update(self.movements[self.currentMove % #self.movements + 1])
        end
        self.currentMove = self.currentMove + 1
    end)
end

--- Damage alien in self.aliens[i]
function M:damage(i)
    return self.aliens[i]:damage()
end

--- Returns if there's any alien alive
function M:anyAlive()
    for _, alien in ipairs(self.aliens) do
        if alien:isAlive() then
            return true
        end
    end
    return false
end

--- Make all aliens try to shoot
--- The more high the evilness, more is the probability o the alien shoot
--- 
--- The bullet will be inserted in the list `bullets`
---
--- Notice that more than an alien can shoot at the same time
function M:shoot(dt, target, evilness, bullets)
    for _, alien in ipairs(self.aliens) do
        if alien:isAlive() then
            local value = love.math.random() -- Who wouldn't love math
            if value < dt * evilness then
                bullets[#bullets + 1] = alien:shoot(target)
            end
        end
    end
end

--- Returns if the swarm reached the bottom row
function M:reachBottomRow()
    for _, alien in ipairs(self.aliens) do
        if alien:isAlive() and alien:reachBottomRow() then
            return true
        end
    end
    return false
end

return M

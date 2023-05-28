local Vec = require'modules.Vec'
local Alien = require'objects.Alien'
local timer = require'modules.timer'

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

local function new(_, opts)
    local n = opts[1]
    local m = opts[2]
    local d = opts[3]
    local t = opts.timing

    local aliens = {}
    for i = 1, n do
        for j = 1, m do
            aliens[#aliens + 1] = Alien{Vec(1.5 * j - 1, 1.5 * i), health = 1}
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
        timer = timer.Timer(t),
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:draw()
    for _, alien in ipairs(self.aliens) do
        alien:draw()
    end
end

function M:update(dt)
    self.timer:update(dt)
    self.timer:clock(function()
        for _, alien in ipairs(self.aliens) do
            alien:update(self.movements[self.currentMove % #self.movements + 1])
        end
        self.currentMove = self.currentMove + 1
    end)
end

function M:damage(i)
    return self.aliens[i]:damage()
end

function M:anyAlive()
    for _, alien in ipairs(self.aliens) do
        if alien:isAlive() then
            return true
        end
    end
    return false
end

return M

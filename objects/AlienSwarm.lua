local Vec = require'modules.Vec'
local Alien = require'objects.Alien'
local time = require'modules.time'

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
            aliens[#aliens + 1] = Alien(Vec(1.5 * j - 1, 1.5 * i))
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
        m = 0,
        timer = time.Timer(t),
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})


function M:draw()
    for _, a in ipairs(self.aliens) do
        a:draw()
    end
end

function M:update(dt)
    self.timer:update(dt)
    self.timer:clock(function()
        for _, a in ipairs(self.aliens) do
            a:update(self.movements[self.m % #self.movements + 1])
        end
        self.m = self.m + 1
    end)
end

return M

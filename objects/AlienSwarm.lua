local Vec = require'modules.Vec'
local Alien = require'objects.Alien'
local time = require'modules.time'

local M = {_loaded = false}

function M.load(M)
    if not M._loaded then
        M._loaded = true
        Alien:load()
    end
end

M.__index = M

local function new(_, opts)
    local n = opts[1]
    local m = opts[2]
    local d = opts[3]
    local timing = opts.timing

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
        timer = time.Timer(timing),
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})


function M:draw(settings)
    for _, a in ipairs(self.aliens) do
        a:draw(settings)
    end
end

function M:update(dt, settings)
    self.timer:update(dt)
    self.timer:clock(function()
        for _, a in ipairs(self.aliens) do
            a:update(self.movements[self.m % #self.movements + 1], settings)
        end
        self.m = self.m + 1
    end)
end

return M

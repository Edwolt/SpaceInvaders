local inspect = require'utils.inspect'
local Vec = require'modules.Vec'
local Alien = require'objects.Alien'
local Timer = require'modules.Timer'

local M = {_loaded = false}

function M.load(M)
    if not M._loaded then
        Alien:load()
        M._loaded = true
    end
end

M.__index = M

local function new(_, n, m, d)
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
        timer = Timer(0.2),
    }

    return setmetatable(self, M)
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

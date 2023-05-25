local M = {}
M.__index = M

local function new(_, duration)
    local self = {
        time = 0,
        duration = duration or 1,
    }
    return setmetatable(self, M)
end
setmetatable(M, {__call = new})


function M:update(dt)
    self.time = self.time + dt
end

function M:clock(f, ...)
    while self.time > self.duration do
        f(...)
        self.time = self.time - self.duration
    end
end

return M

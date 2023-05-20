local M = {}
M.__index = M

local function new(_, duration)
    local self = {
        timer = 0,
        duration = duration or 1,
    }
    return setmetatable(self, M)
end
setmetatable(M, {__call = new})


function M:update(dt)
    self.timer = self.timer + dt
end

function M:clock()
    local qtt = 0
    while self.timer > self.duration do
        self.timer = self.timer - self.duration
        qtt = qtt + 1
    end
    return qtt
end

return M

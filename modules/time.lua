-- Timer
local T = {}
T.__index = T

local function new(_, duration)
    local self = {
        time = 0,
        duration = duration or 1,
    }

    setmetatable(self, T)
    return self
end
setmetatable(T, {__call = new})


function T:update(dt)
    self.time = self.time + dt
end

function T:clock(f, ...)
    while self.time > self.duration do
        f(...)
        self.time = self.time - self.duration
    end
end

-- Cool Down
local C = {}
C.__index = C

local function new(_, duration)
    local self = {
        time = 0,
        duration = duration or 1,
        active = false,
    }

    setmetatable(self, C)
    return self
end
setmetatable(C, {__call = new})

function C:update(dt)
    self.time = self.time + dt
end

function C:clock(f, ...)
    if not self.active then
        f(...)
        self.time = 0
        self.active = true
    elseif self.time > self.duration then
        self.active = false
    end
end

return {
    Timer = T,
    CoolDown = C,
}

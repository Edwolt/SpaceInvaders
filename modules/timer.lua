--- Interval Timer
local T = {}
T.__index = T

local function new(_, duration)
    local self = {
        time = 0,
        duration = duration,
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
        self.time = self.time - self.duration
        f(...)
    end
end

--- Cool Down Timer
local C = {}
C.__index = C

local function new(_, duration)
    local self = {
        time = 0,
        duration = duration,
        active = false,
    }

    setmetatable(self, C)
    return self
end
setmetatable(C, {__call = new})

function C:update(dt)
    if self.active then
        self.time = self.time + dt
    end
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
    --- Interval Timer
    Timer = T,
    --- Cool Down Timer
    CoolDown = C,
}

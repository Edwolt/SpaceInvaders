local time = require'modules.time'
local keyIsDown = love.keyboard.isDown

M = {}
M.__index = M

local function new(_, settings)
    local BULLET_COOLDOWN = settings.BULLET_COOLDOWN
    local self = {
        shootCooldown = time.Timer(BULLET_COOLDOWN),
        shootPressed = false,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:update(dt)
    self.shootCooldown:update(dt)
end

function M:right(f, ...)
    if keyIsDown'right' or keyIsDown'a' then
        f(...)
    end
end

function M:left(f, ...)
    if keyIsDown'left' or keyIsDown'd' then
        f(...)
    end
end

function M:shoot(f, ...)
    local args = ...
    local run = false

    if keyIsDown'space' or keyIsDown'w' then
        self.spacePressed = true
    end

    inspect{self}
    self.shootCooldown:clock(function()
        if self.spacePressed then
            f(unpack(args))
            run = true
        end
    end)

    if run then
        self.spacePressed = false
    end
end

return M

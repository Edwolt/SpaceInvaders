local time = require'modules.time'
local keyIsDown = love.keyboard.isDown

M = {}
M.__index = M

local function new(_)
    local BULLET_COOLDOWN = SETTINGS.BULLET_COOLDOWN
    local self = {
        shootCooldown = time.CoolDown(BULLET_COOLDOWN),
        shootPressed = false,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:update(dt)
    self.shootCooldown:update(dt)
end

----- Special Keys -----

function M:quit(f, ...)
    if keyIsDown'l' then
        f(...)
    end
end

function M:pause(f, ...)
    if keyIsDown'escape' then
        f(...)
    end
end

function M:fullscreen(f, ...)
    if keyIsDown'f' or keyIsDown'f11' then
        f(...)
    end
end

function M:debug(f, ...)
    if keyIsDown'c' then
        f(...)
    end
end

----- Game keys -----

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
    if keyIsDown'space' or keyIsDown'w' then
        self.spacePressed = true
    end

    if self.spacePressed then
        self.shootCooldown:clock(function(...)
            f(...)
        end, ...)
        self.spacePressed = false
    end
end

return M

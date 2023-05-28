local keyIsDown = love.keyboard.isDown
local timer = require'modules.timer'

M = {}
M.__index = M

local function new(_)
    local SPECIALKEY_COOLDOWN = SETTINGS.SPECIALKEY_COOLDOWN
    local BULLET_COOLDOWN = SETTINGS.BULLET_COOLDOWN

    local self = {
        cooldown = {
            pause = timer.CoolDown(SPECIALKEY_COOLDOWN),
            fullscreen = timer.CoolDown(SPECIALKEY_COOLDOWN),
            debug = timer.CoolDown(SPECIALKEY_COOLDOWN),
            giveup = timer.CoolDown(SPECIALKEY_COOLDOWN),
            next = timer.CoolDown(SPECIALKEY_COOLDOWN),

            shoot = timer.CoolDown(BULLET_COOLDOWN),
        },
        shootPressed = false,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:update(dt)
    for _, cooldown in pairs(self.cooldown) do
        cooldown:update(dt)
    end
end

----- Special Keys -----

function M:quit(f, ...)
    if keyIsDown'l' then
        f(...)
    end
end

function M:pause(f, ...)
    if keyIsDown'escape' then
        self.cooldown.pause:clock(function(...)
            f(...)
        end, ...)
    end
end

function M:fullscreen(f, ...)
    if keyIsDown'f' or keyIsDown'f11' then
        self.cooldown.fullscreen:clock(function(...)
            f(...)
        end, ...)
    end
end

function M:debug(f, ...)
    if keyIsDown'c' then
        self.cooldown.debug:clock(function(...)
            f(...)
        end, ...)
    end
end

function M:giveup(f, ...)
    if keyIsDown'g' then
        self.cooldown.giveup:clock(function(...)
            f(...)
        end, ...)
    end
end

function M:next(f, ...)
    if keyIsDown'n' then
        self.cooldown.giveup:clock(function(...)
            f(...)
        end, ...)
    end
end

function M:fast(f, ...)
    if keyIsDown'p' then
        self.cooldown.giveup:clock(function(...)
            f(...)
        end, ...)
    end
end

----- Game keys -----

function M:left(f, ...)
    if keyIsDown'left' or keyIsDown'a' then
        f(...)
    end
end

function M:right(f, ...)
    if keyIsDown'right' or keyIsDown'd' then
        f(...)
    end
end

function M:shoot(f, ...)
    if keyIsDown'space' or keyIsDown'w' then
        self.cooldown.shoot:clock(function(...)
            f(...)
        end, ...)
    end
end

return M

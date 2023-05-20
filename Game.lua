local inspect = require'modules.inspect'
local Vec = require'modules.Vec'
local Timer = require'modules.Timer'

local Spaceship = require'objects.Spaceship'
local Enemy = require'objects.Enemy'

local M = {
    SCALE = Vec(love.graphics.getWidth() / (50 * 16), love.graphics.getHeight() / (60 * 16)),
    BLOCK_SIZE = Vec(16, 16),
    SPACESHIP_VELOCITY = 50,
    load = function(M)
        Spaceship:load()
        Enemy:load()
    end,
}
M.__index = M

local function new(_)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local dim = Vec(w, h)

    local spaceship = Spaceship()
    inspect{Spaceship, name = 'Spaceship'}
    inspect{spaceship.tam / 2, name = 'spaceship'}
    spaceship.pos = spaceship.pos - spaceship.tam / 2

    local enemy = Enemy()
    enemy.pos = Vec(100, 100)

    local self = {
        spaceship = Spaceship(Vec(49, 59)),
        enemy = enemy,
        timer = Timer(2),
    }

    return setmetatable(self, M)
end
setmetatable(M, {__call = new})


function M:draw()
    self.spaceship:draw{scale = self.SCALE}
    self.enemy:draw{scale = self.SCALE}
end

function M:update(dt)
    self.timer:update(dt)
    local keyIsDown = love.keyboard.isDown

    -- Update spaceship movement direction
    local dir = Vec(0, 0)
    if keyIsDown'right' or keyIsDown'd' then
        dir = dir + Vec(1, 0)
    elseif keyIsDown'left' or keyIsDown'a' then
        dir = dir + Vec( -1, 0)
        -- elseif keyIsDown'up' or keyIsDown'w' then
        --     dir = dir + Vec(0, -1)
        -- elseif keyIsDown'down' or keyIsDown's' then
        --     dir = dir + Vec(0, 1)
    end
    self.spaceship:move(dir:versor())

    -- Update Spaceship
    self.spaceship:update{dt, VELOCITY = self.SPACESHIP_VELOCITY}

    -- Update Enemy
    for i = 0, self.timer:clock() - 1 do
        print(dt, self.timer.timer)
        self.enemy:update{direction = 'right'}
    end
end

return M

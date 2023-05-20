local inspect = require'modules.inspect'
local Vec = require'modules.Vec'
local Timer = require'modules.Timer'

local Spaceship = require'objects.Spaceship'
local Enemy = require'objects.Enemy'


local M = {
    settings = nil,
}

function M.load(M)
    local SETTINGS = {
        BLOCK_SIZE = Vec(16, 16),
        BLOCK_NUMBER = Vec(18, 15),
        SPACESHIP_VELOCITY = 5,
    }
    SETTINGS.SCALE = Vec.window_size() /
        (SETTINGS.BLOCK_SIZE * SETTINGS.BLOCK_NUMBER)

    M.settings = SETTINGS

    Spaceship:load()
    Enemy:load()
end

M.__index = M


local function new(_)
    local dim = Vec.window_size()

    local spaceship = Spaceship()
    spaceship.pos.x = M.settings.BLOCK_NUMBER.x / 2 -
        spaceship:size(M.settings).x / 2
    spaceship.pos.y = M.settings.BLOCK_NUMBER.y - 1
    inspect{spaceship, 'spaceship'}

    local enemy = Enemy()
    enemy.pos.x = 1
    enemy.pos.y = 1

    local self = {
        spaceship = spaceship,
        enemy = enemy,
        timer = Timer(2),
    }

    return setmetatable(self, M)
end
setmetatable(M, {__call = new})


function M:draw()
    self.spaceship:draw(self.settings)
    self.enemy:draw(self.settings)
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
    self.spaceship:update(dt, self.settings)

    -- Update Enemy
    for i = 0, self.timer:clock() - 1 do
        print(dt, self.timer.timer)
        inspect{self.settings, 'settings'}
        self.enemy:update('right', self.settings)
    end
end

return M

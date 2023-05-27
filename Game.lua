local Vec = require'modules.Vec'
local time = require'modules.time'
local Key = require'modules.key'

local Spaceship = require'objects.Spaceship'
local AlienSwarm = require'objects.AlienSwarm'
local HUD = require'objects.HUD'
local Bullet = require'objects.Bullet'

local M = {
    SETTINGS = nil,
}

function M.load(M)
    local SETTINGS = {
        BLOCK_SIZE = Vec(16, 16),
        SCREEN_BLOCKS = Vec(16, 15),
        SPACESHIP_VELOCITY = 5,
        BULLET_VELOCITY = 15,
        KEYBOARD_COOLDOWN = 0.2,
    }
    SETTINGS.SCALE = Vec.window_size() /
        (SETTINGS.BLOCK_SIZE * SETTINGS.SCREEN_BLOCKS)

    M.key = Key(SETTINGS)
    M.SETTINGS = SETTINGS

    Spaceship:load()
    AlienSwarm:load()
    HUD:load()
end

M.__index = M


local function new(_)
    local SCREEN_BLOCKS = M.SETTINGS.SCREEN_BLOCKS

    local spaceship = Spaceship()
    local spaceship_size = spaceship:size(M.SETTINGS)
    spaceship.pos.x = SCREEN_BLOCKS.x / 2 - spaceship_size.x / 2
    spaceship.pos.y = SCREEN_BLOCKS.y - 1

    local self = {
        score = HUD(),
        spaceship = spaceship,
        swarm = AlienSwarm{3, 7, 5, timer = 2} ,
        bullets_timers = {
            clean = time.Timer(1),
        },
        bullets = {},
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})


function M:draw()
    self.score:draw(self.SETTINGS)
    self.spaceship:draw(self.SETTINGS)
    self.swarm:draw(self.SETTINGS)
    for _, b in ipairs(self.bullets) do
        b:draw(self.SETTINGS)
    end
end

function M:update(dt)
    local key = self.key

    -- Update spaceship movement direction
    local dir = Vec(0, 0)
    key:right(function()
        dir.x = dir.x + 1
    end)
    key:left(function()
        dir.x = dir.x - 1
    end)
    key:shoot(function()
        self.bullets[#self.bullets + 1] = Bullet(self.spaceship.pos)
    end)
    self.spaceship:move(dir:versor())

    -- Updates
    self.spaceship:update(dt, self.SETTINGS)
    self.swarm:update(dt, self.SETTINGS)

    self.bullets_timers.cooldown:update(dt)
    self.bullets_timers.clean:update(dt)

    for _, b in ipairs(self.bullets) do
        b:update(dt, self.SETTINGS)
    end

    -- Clen out of screen bullets
    self.bullets_timers.clean:clock(function()
        local new_bullets = {}
        for _, b in ipairs(self.bullets) do
            if b.pos:isOnScreen(self.SETTINGS) then
                new_bullets[#new_bullets + 1] = b
            end
        end
        self.bullets = new_bullets
        inspect{#self.bullets, '#new_bullets'}
    end)


    inspect{#self.bullets, '#bullets'}
end

function M:resize()
    local BLOCK_SIZE = self.SETTINGS.BLOCK_SIZE
    local SCREEN_BLOCKS = self.SETTINGS.SCREEN_BLOCKS

    self.SETTINGS.SCALE = Vec.window_size() / (BLOCK_SIZE * SCREEN_BLOCKS)
end

return M

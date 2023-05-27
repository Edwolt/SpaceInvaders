local Vec = require'modules.Vec'
local time = require'modules.time'
local Key = SETTINGS.Key

local Spaceship = require'objects.Spaceship'
local AlienSwarm = require'objects.AlienSwarm'
local Text = require'objects.Text'
local HUD = require'objects.HUD'
local Bullet = require'objects.Bullet'

local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dbg.log.load'Game'

        Spaceship:load()
        AlienSwarm:load()
        HUD:load()

        dbg.log.loaded'Game'
    end,
}
M.__index = M


local function new(_)
    local SCREEN_BLOCKS = SETTINGS.SCREEN_BLOCKS

    local spaceship = Spaceship(Vec(0, 0))
    local spaceship_size = spaceship:size()
    spaceship.pos.x = SCREEN_BLOCKS.x / 2 - spaceship_size.x / 2
    spaceship.pos.y = SCREEN_BLOCKS.y - 1

    local self = {
        hud = HUD(),
        spaceship = spaceship,
        swarm = AlienSwarm{3, 7, 5, timing = SETTINGS.SWARM_TIMING} ,
        bullets_timer_clean = time.Timer(5),
        bullets = {},
        debug = false,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})


function M:draw()
    self.hud:draw()
    self.spaceship:draw()
    self.swarm:draw()
    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end

    if self.debug then
        self.spaceship:collider():draw()
        self.swarm:collider():draw()
        for _, bullet in ipairs(self.bullets) do
            bullet:collider():draw()
        end
    end
end

function M:pauseDraw()
    self.hud:draw()
    self.spaceship:draw()
    self.spaceship:draw()

    local size = 3
    local text = '% PAUSE'
    local pos = SETTINGS.SCREEN_BLOCKS / 2
    pos.y = pos.y - 3 -- Space to instructions
    pos.x = pos.x - #text / 2
    pos = pos - size / 2
    Text:draw(pos, size, text)

    pos.y = pos.y + 4
    Text:draw(pos + Vec(3, 0), 1, '+>MOVE')
    Text:draw(pos + Vec(2.5, 1), 1, '[]>SHOOT')
    Text:draw(pos + Vec(3, 2), 1, 'F>FULLSCREEN')
    Text:draw(pos + Vec(3, 3), 1, 'L>LEAVE')
    Text:draw(pos + Vec(3, 4), 1, 'C>DEBUG')
end

function M:update(dt)
    Key:update(dt)

    -- Update spaceship movement direction
    local dir = Vec(0, 0)
    Key:right(function()
        dir.x = dir.x + 1
    end)
    Key:left(function()
        dir.x = dir.x - 1
    end)
    Key:shoot(function()
        self.bullets[#self.bullets + 1] = Bullet(self.spaceship.pos)
    end)
    self.spaceship:move(dir:versor())

    -- Updates
    self.spaceship:update(dt)
    self.swarm:update(dt)

    self.bullets_timer_clean:update(dt)

    for _, bullet in ipairs(self.bullets) do
        bullet:update(dt)
    end

    -- Clen out of screen bullets
    self.bullets_timer_clean:clock(function()
        local new_bullets = {}
        for _, bullet in ipairs(self.bullets) do
            if bullet.pos:isOnScreen() then
                new_bullets[#new_bullets + 1] = bullet
            end
        end
        self.bullets = new_bullets
        dbg.inspect{#self.bullets, '#bullets'}
    end)
end

return M

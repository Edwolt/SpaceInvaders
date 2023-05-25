local inspect = require'utils.inspect'
local Vec = require'modules.Vec'

local Spaceship = require'objects.Spaceship'
local AlienSwarm = require'objects.AlienSwarm'

local M = {
    SETTINGS = nil,
}

function M.load(M)
    local SETTINGS = {
        BLOCK_SIZE = Vec(16, 16),
        BLOCK_NUMBER = Vec(16, 15),
        SPACESHIP_VELOCITY = 5,
    }
    SETTINGS.SCALE = Vec.window_size() /
        (SETTINGS.BLOCK_SIZE * SETTINGS.BLOCK_NUMBER)

    M.SETTINGS = SETTINGS

    Spaceship:load()
    AlienSwarm:load()
end

M.__index = M


local function new(_)
    local dim = Vec.window_size()

    local spaceship = Spaceship()
    spaceship.pos.x = M.SETTINGS.BLOCK_NUMBER.x / 2 -
        spaceship:size(M.SETTINGS).x / 2
    spaceship.pos.y = M.SETTINGS.BLOCK_NUMBER.y - 1
    inspect{spaceship, 'spaceship'}

    local self = {
        spaceship = spaceship,
        swarm = AlienSwarm(3, 7, 5),
    }

    return setmetatable(self, M)
end
setmetatable(M, {__call = new})


function M:draw()
    self.spaceship:draw(self.SETTINGS)
    self.swarm:draw(self.SETTINGS)
end

function M:update(dt)
    local keyIsDown = love.keyboard.isDown

    -- Update spaceship movement direction
    local dir = Vec(0, 0)
    if keyIsDown'right' or keyIsDown'd' then
        dir.x = dir.x + 1
    end
    if keyIsDown'left' or keyIsDown'a' then
        dir.x = dir.x - 1
    end

    self.spaceship:move(dir:versor())

    -- Update Spaceship
    self.spaceship:update(dt, self.SETTINGS)

    -- Update Aliens
    self.swarm:update(dt, self.SETTINGS)
end

function M:resize()
    self.SETTINGS.SCALE = Vec.window_size() /
        (self.SETTINGS.BLOCK_SIZE * self.SETTINGS.BLOCK_NUMBER)
end

return M

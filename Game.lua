local Vec = require'modules.Vec'

local Spaceship = require'objects.Spaceship'
local AlienSwarm = require'objects.AlienSwarm'
local Score = require'objects.Score'

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
    Score:load()
end

M.__index = M


local function new(_)
    local BLOCK_NUMBER = M.SETTINGS.BLOCK_NUMBER

    local spaceship = Spaceship()
    local spaceship_size = spaceship:size(M.SETTINGS)
    spaceship.pos.x = BLOCK_NUMBER.x / 2 - spaceship_size.x / 2
    spaceship.pos.y = BLOCK_NUMBER.y - 1

    local self = {
        score = Score(),
        spaceship = spaceship,
        swarm = AlienSwarm(3, 7, 5),
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})


function M:draw()
    self.score:draw(self.SETTINGS)
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

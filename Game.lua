local color = require'modules.color'
local Vec = require'modules.Vec'
local timer = require'modules.timer'
local Collider = require'modules.Collider'
local Key = SETTINGS.Key

local Spaceship = require'objects.Spaceship'
local AlienSwarm = require'objects.AlienSwarm'
local BonusAlien = require'objects.BonusAlien'
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
        BonusAlien:load()
        HUD:load()
        Bullet:load()

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
        state = {
            debug = false,
            pause = false,
            gameOver = false,
            fast = false,
        },
        hud = HUD(),
        spaceship = spaceship,
        swarm = AlienSwarm{3, 7, 5, timing = SETTINGS.SWARM_TIMING} ,
        bonusAlien = nil,
        timer = {
            clean = timer.CoolDown(5),
            bonus = timer.Timer(SETTINGS.BONUS_TIME()),
        },
        bullets = {
            spaceship = {},
            aliens = {},
        },
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:draw()
    -- Visibility depends on state
    if self.state.pause then
        self:drawPause()
    elseif self.state.gameOver then
        self:drawGameOver()
    elseif self.state.debug then
        self:drawDebug()
    else
        self:drawGame()
    end

    -- Always visible
    self.hud:draw(self.spaceship)
    self.spaceship:draw()
    if self.state.debug then
        self:drawState()
    end
end

function M:drawGame()
    self.swarm:draw()
    if self.bonusAlien ~= nil then
        self.bonusAlien:draw()
    end
    for _, bullet in ipairs(self.bullets.spaceship) do
        bullet:draw()
    end
    for _, bullet in ipairs(self.bullets.aliens) do
        bullet:draw()
    end
end

function M:drawDebug()
    love.graphics.setColor(color.BLACK)
    local col = Collider.screenCollider()
    love.graphics.rectangle(
        'fill',
        col.pos.x, col.pos.y,
        col.size.x, col.size.y
    )

    self:drawGame()

    self.spaceship:collider():draw(color.BLUE)

    for _, alien in ipairs(self.swarm.aliens) do
        alien:collider():draw(
            alien:isAlive() and color.RED or color.MAGENTA
        )

        love.graphics.setColor(color.GREEN)
        Text:draw(alien.pos, 0.5, tostring(alien:killScore()))
    end

    if self.bonusAlien ~= nil then
        self.bonusAlien:collider():draw(
            self.bonusAlien:isAlive() and color.RED or color.MAGENTA
        )

        love.graphics.setColor(color.GREEN)
        Text:draw(self.bonusAlien.pos, 0.5, tostring(self.bonusAlien:killScore()))
    end

    for _, bullet in ipairs(self.bullets.spaceship) do
        bullet:collider():draw(
            bullet:isAlive() and color.YELLOW or color.GREEN
        )
    end

    self:drawState()
end

function M:drawState()
    self.hud:drawState(self.state)
end

function M:drawPause()
    local text = '% PAUSE'
    local size = 3
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
end

function M:drawGameOver()
    love.graphics.setColor(color.ORANGE)
    inspect{color.ORANGE, 'color'}
    inspect{{love.graphics.getColor()}, 'Color'}
    local text
    if self.swarm:reachBottomRow() then
        text = {'EARTH IS', 'DOOMED'}
    elseif self.spaceship:isAlive() then
        text = {'CONGRATS'}
    elseif self.swarm:anyAlive() then
        text = {'MISSION', 'FAILED'}
    end

    for i = 1, #text do
        local size = 3
        local pos = SETTINGS.SCREEN_BLOCKS / 2
        pos = pos + size * Vec(
                ( -(0.5 + #text[i]) / 2) / 2,
                (i - 1) - #text / 2
            )
        Text:draw(pos, size, text[i])
    end
end

function M:keydown()
    -- Special keys
    Key:quit(function()
        dbg.print'quit'
        self.hud:updateHighscore()
        love.event.quit(0)
    end)

    Key:pause(function()
        dbg.print'toggle pause'
        self.state.pause = not self.state.pause
    end)

    Key:fullscreen(function()
        dbg.print'toggle fullscreen'
        love.window.setFullscreen(not love.window.getFullscreen())
    end)

    Key:debug(function()
        dbg.print'set debug'
        self.state.debug = not self.state.debug
    end)

    Key:giveup(function()
        dbg.print'giveup'
        self.spaceship.lifes = -1
    end)

    Key:next(function()
        dbg.print'go to next level'
        local dscore = 0
        for _, alien in ipairs(self.swarm.aliens) do
            while alien:isAlive() do
                dscore = dscore + alien:damage()
            end
        end
        self.hud:addScore(dscore)
    end)

    Key:fast(function()
        self.state.fast = not self.state.fast
    end)

    -- Game movemnets
    local dir = Vec(0, 0)
    Key:shoot(function()
        self.bullets.spaceship[#self.bullets.spaceship + 1] = Bullet(self
        .spaceship.pos)
    end)
    Key:right(function()
        dir.x = dir.x + 1
    end)
    Key:left(function()
        dir.x = dir.x - 1
    end)
    self.spaceship:move(dir)
end

function M:handleGameOver()
    if self.state.gameover then
        return
    end
    local gameOver =
        not self.spaceship:isAlive() or
        not self.swarm:anyAlive() or
        self.swarm:reachBottomRow()

    if not gameOver then
        -- The game must continue
        return
    end

    if not self.spaceship:isAlive() then
        dbg.print'Game Over: Spaceship destroyed'
    end
    if not self.swarm:anyAlive() then
        dbg.print'Game Over: Earth is safe'
    end
    if self.swarm:reachBottomRow() then
        dbg.print'Game Over: Earth invaded'
    end

    self.state.gameOver = true
    self.hud:updateHighscore()
end

-- Clean objects out of screen
function M:clean()
    self.timer.clean:clock(function()
        local newBullets = {}
        for i, bullet in ipairs(self.bullets.spaceship) do
            local onScreen = bullet
                :collider()
                :collision(Collider.screenCollider())

            if onScreen and bullet:isAlive() then
                newBullets[#newBullets + 1] = bullet
            end
        end
        self.bullets.spaceship = newBullets

        local newBullets = {}
        for i, bullet in ipairs(self.bullets.aliens) do
            local onScreen = bullet
                :collider()
                :collision(Collider.screenCollider())

            if not onScreen or not bullet:isAlive() then
                newBullets[#newBullets + 1] = bullet
            end
        end

        local onScreen = self.bonusAlien and self.bonusAlien
            :collider()
            :collision(Collider.screenCollider())

        if not onScreen then
            self.bonusAlien = nil
        end

        dbg.print'Clean'
        dbg.inspect{#self.bullets.spaceship, '#bullets.spaceship'}
        dbg.inspect{#self.bullets.aliens, '#bullets.aliens'}
        dbg.print('#bonusAlien = ' .. (self.bonusAlien and 1 or 0))
    end)
end

function M:update(dt)
    if self.state.pause then
        return
    end
    if self.state.gameOver then
        return
    end
    if self.state.fast then
        dt = 10 * dt
    end

    local SCREEN_BLOCKS = SETTINGS.SCREEN_BLOCKS
    local EVILNESS = SETTINGS.EVILNESS

    -- Updates
    for _, timer in pairs(self.timer) do
        timer:update(dt)
    end

    self.spaceship:update(dt)
    self.swarm:update(dt)
    if self.bonusAlien ~= nil then
        self.bonusAlien:update(dt)
    end

    for _, bullet in ipairs(self.bullets.spaceship) do
        bullet:update(dt)
    end
    for _, bullet in ipairs(self.bullets.aliens) do
        bullet:update(dt)
    end

    self.swarm:shoot(dt, EVILNESS, self.bullets.aliens)
    self.timer.bonus:clock(function()
        self.timer.bonus.duration = SETTINGS.BONUS_TIME()

        local dir = love.math.random() < 0.5
        if dir then
            self.bonusAlien = BonusAlien(
                Vec( -1, 1),
                Vec(SETTINGS.SPACESHIP_VELOCITY, 0)
            )
        else
            self.bonusAlien = BonusAlien(
                Vec(SCREEN_BLOCKS.x, 1),
                Vec( -SETTINGS.SPACESHIP_VELOCITY, 0)
            )
        end

        dbg.print'Spawned Bonus Alien'
    end)

    -- Clean objects out of screen
    self:clean()

    -- Collsions
    local col_spaceshipBullets = {}
    for i, bullet in ipairs(self.bullets.spaceship) do
        col_spaceshipBullets[i] = bullet:collider()
    end

    local col_aliensBullets = {}
    for i, bullet in ipairs(self.bullets.aliens) do
        col_aliensBullets[i] = bullet:collider()
    end

    local col_aliens = {}
    for i, alien in ipairs(self.swarm.aliens) do
        col_aliens[i] = alien:collider()
    end

    local col_spaceship = {self.spaceship:collider()}
    local col_bonusAlien = {}
    if self.bonusAlien ~= nil then
        col_bonusAlien[#col_bonusAlien + 1] = self.bonusAlien:collider()
    end

    Collider.checkCollisionsNtoM(
        col_spaceshipBullets, col_aliens,
        function(i, j)
            local bullet = self.bullets.spaceship[i]
            local alien = self.swarm.aliens[j]

            if not bullet:isAlive() then
                return 'continue' -- Go to next bullet
            end

            if not alien:isAlive() then
                return -- Go to next alien
            end

            bullet:damage()
            local dscore = self.swarm:damage(j)
            self.hud:addScore(dscore)
        end
    )


    Collider.checkCollisionsNtoM(
        col_spaceship, col_aliensBullets,
        function(i, j)
            local spaceship = self.spaceship
            local bullet = self.bullets.aliens[j]

            if not spaceship:isAlive() then
                return 'break' -- There's no need to continue chicking collision
            end

            if not bullet:isAlive() then
                return -- Go to next bullet
            end

            bullet:damage()
            spaceship:damage()
        end
    )

    Collider.checkCollisionsNtoM(
        col_bonusAlien, col_spaceshipBullets,
        function(i, j)
            local bonusAlien = self.bonusAlien
            local bullet = self.bullets.spaceship[j]

            if not bonusAlien:isAlive() then
                return 'break' -- There's no need to continue chicking collision
            end

            if not bullet:isAlive() then
                return -- Go to next bullet
            end

            bullet:damage()
            local dscore = bonusAlien:damage()
            self.hud:addScore(dscore)
        end
    )

    self:handleGameOver()
end

return M

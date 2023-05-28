local Key = require'modules.key'
local Vec = require'modules.Vec'

SETTINGS = {
    -- Screen
    BLOCK_SIZE = Vec(16, 16),
    SCREEN_BLOCKS = Vec(16, 15),
    SPACESHIP_VELOCITY = 5,
    -- Bullet
    BULLET_VELOCITY = Vec(0, -15),
    BULLET_COOLDOWN = 0.7,
    -- ALIENS
    SWARM_TIMING = 2,
    SWARM_SIZE = {numColumns = 7, numMovements = 5},
    LEVEL_SWARM_ROWS = {
        [1] = {1, 1, 1},
        [2] = {1, 1, 1, 1},
        [3] = {2, 1, 1, 1},
        [4] = {2, 1, 1, 2},
        [5] = {2, 3, 1, 1},
        [6] = {2, 1, 1, 2},
        [7] = {2, 3, 3, 2},
        [8] = {3, 3, 2, 2},
        [9] = {3, 3, 2, 2, 2},
        [10] = {3, 3, 3, 2, 2, 2},
    },
    EVILNESS = 0.03,
    BONUS_TIME = function()
        return 7 + 14 * love.math.random()
    end,
    -- Score
    ALIEN_ROW_SCORE = function(row)
        if row <= 3 then
            return 200
        elseif row <= 5 then
            return 150
        elseif row <= 8 then
            return 100
        elseif row <= 12 then
            return 50
        else
            return 25
        end
    end,
    BONUS_ALIEN_SCORE = 500,
    HIGHSCORE_PATH = 'highscore.txt',
    -- Special Keys
    SPECIALKEY_COOLDOWN = 0.2,
}

function SETTINGS.SCALE()
    return Vec.windowSize() /
        (SETTINGS.BLOCK_SIZE * SETTINGS.SCREEN_BLOCKS)
end

SETTINGS.Key = Key()

return SETTINGS

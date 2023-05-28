local Key = require'modules.key'
local Vec = require'modules.Vec'

SETTINGS = {
    -- Screen
    BLOCK_SIZE = Vec(16, 16),
    SCREEN_BLOCKS = Vec(16, 15),
    SPACESHIP_VELOCITY = 5,
    -- Bullet
    BULLET_VELOCITY = Vec(0, 15),
    BULLET_COOLDOWN = 0.7,
    -- Swarm
    SWARM_TIMING = 2,
    EVILNESS = 0.03,
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

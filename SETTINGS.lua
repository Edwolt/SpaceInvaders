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
    SCORE_FACTOR = 100,
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

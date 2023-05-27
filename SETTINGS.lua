local Key = require'modules.key'
local Vec = require'modules.Vec'

SETTINGS = {
    BLOCK_SIZE = Vec(16, 16),
    SCREEN_BLOCKS = Vec(16, 15),
    SPACESHIP_VELOCITY = 5,
    BULLET_VELOCITY = 15,
    BULLET_COOLDOWN = 0.7,
    SWARM_TIMING = 2,
}

function SETTINGS.SCALE()
    return Vec.window_size() /
        (SETTINGS.BLOCK_SIZE * SETTINGS.SCREEN_BLOCKS)
end

SETTINGS.Key = Key()

return SETTINGS

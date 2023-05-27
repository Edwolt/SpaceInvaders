local Vec = require'modules.Vec'

local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dbg.log.load'Text'

        M.sprite = love.graphics.newImage'assets/font.png'

        local size = Vec.image_size(M.sprite)
        local sprite_text = 'HIGSCORE:1234567890 '
        M.QUADS = {}
        for i = 1, #sprite_text do
            local c = sprite_text:sub(i, i)
            M.QUADS[c] = love.graphics.newQuad(
                (i - 1) * 8, 0,
                8, 16,
                size.x, size.y
            )
        end
        dbg.log.loaded'Text'
    end,
}
M.__index = M

local function new(_, high_score)
    local self = {
        high_score = high_score or 0,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M:draw(pos, size, text)
    local SCALE = size * SETTINGS.SCALE()
    for i = 1, #text do
        local c = text:sub(i, i)

        local screen_pos = Vec(pos.x + i - 1, pos.y):toscreen{font = true}
        local quad = self.QUADS[c]
        if quad == nil then
            error(string.format('No font specified for char %q', tostring(c)))
        end
        love.graphics.draw(
            self.sprite, quad,
            screen_pos.x, screen_pos.y, 0,
            SCALE.x, SCALE.y
        )
    end
end

return M

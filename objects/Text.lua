local Vec = require'modules.Vec'
local color = require'modules.color'
local quads = require'modules.quads'

local M = {
    _loaded = false,
    load = function(M)
        if M._loaded then
            return
        end
        M._loaded = true
        dbg.log.load'Text'

        M.SPRITE = love.graphics.newImage'assets/font.png'

        local size = Vec.imageSize(M.SPRITE)
        local spriteText = ' 0123456789HIGSCOREPAUMVTFLNDB:%>+[]'
        M.QUADS = {}

        M.QUADS['nil'] = love.graphics.newQuad(
            (0) * 8, 0,
            8, 16,
            size.x, size.y
        )

        for i = 1, #spriteText do
            local c = spriteText:sub(i, i)
            M.QUADS[c] = love.graphics.newQuad(
                (i) * 8, 0,
                8, 16,
                size.x, size.y
            )
        end
        dbg.log.loaded'Text'
    end,
}
M.__index = M

function M:draw(pos, size, text)
    local FONT_SIZE = size * SETTINGS.SCALE()

    for i = 1, #text do
        local c = text:sub(i, i)

        local dpos = size * Vec((i - 1) / 2, 0)
        local screen_pos = (pos + dpos):toscreen()
        local quad = self.QUADS[c]
        if quad == nil then
            dbg.print(string.format('No font specified for char %q', c))
            quad = self.QUADS['nil']
        end
        love.graphics.draw(
            self.SPRITE, quad,
            screen_pos.x, screen_pos.y, 0,
            FONT_SIZE.x, FONT_SIZE.y
        )
    end
end

return M

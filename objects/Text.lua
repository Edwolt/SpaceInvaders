local inspect = require'utils.inspect'
local clamp = require'utils.clamp'

local Vec = require'modules.Vec'

local M = {
    _loaded = false,
}

function M.load(M)
    if not M._loaded then
        M.sprite = love.graphics.newImage'images/font.png'
        M._loaded = true

        local size = Vec.image_size(M.sprite)

        M.QUADS = {
            ['H'] = love.graphics.newQuad(0 * 8, 0, 8, 16, size.x, size.y),
            ['I'] = love.graphics.newQuad(1 * 8, 0, 8, 16, size.x, size.y),
            ['G'] = love.graphics.newQuad(2 * 8, 0, 8, 16, size.x, size.y),
            ['S'] = love.graphics.newQuad(3 * 8, 0, 8, 16, size.x, size.y),
            ['C'] = love.graphics.newQuad(4 * 8, 0, 8, 16, size.x, size.y),
            ['O'] = love.graphics.newQuad(5 * 8, 0, 8, 16, size.x, size.y),
            ['R'] = love.graphics.newQuad(6 * 8, 0, 8, 16, size.x, size.y),
            ['E'] = love.graphics.newQuad(7 * 8, 0, 8, 16, size.x, size.y),
            [':'] = love.graphics.newQuad(8 * 8, 0, 8, 16, size.x, size.y),
            ['1'] = love.graphics.newQuad(9 * 8, 0, 8, 16, size.x, size.y),
            ['2'] = love.graphics.newQuad(10 * 8, 0, 8, 16, size.x, size.y),
            ['3'] = love.graphics.newQuad(11 * 8, 0, 8, 16, size.x, size.y),
            ['4'] = love.graphics.newQuad(12 * 8, 0, 8, 16, size.x, size.y),
            ['5'] = love.graphics.newQuad(13 * 8, 0, 8, 16, size.x, size.y),
            ['6'] = love.graphics.newQuad(14 * 8, 0, 8, 16, size.x, size.y),
            ['7'] = love.graphics.newQuad(15 * 8, 0, 8, 16, size.x, size.y),
            ['8'] = love.graphics.newQuad(16 * 8, 0, 8, 16, size.x, size.y),
            ['9'] = love.graphics.newQuad(17 * 8, 0, 8, 16, size.x, size.y),
            ['0'] = love.graphics.newQuad(18 * 8, 0, 8, 16, size.x, size.y),
            [' '] = love.graphics.newQuad(19 * 8, 0, 8, 16, size.x, size.y),
        }

        for c, q in pairs(M.QUADS) do
            x, y, w, h = q:getViewport()
            print("['" .. c .. "'] = ", x, y, w, h)
        end
    end
end

M.__index = M

function M:drawText(pos, text, settings)
    local SCALE = settings.SCALE / 2
    for i = 1, #text do
        local c = text:sub(i, i)

        local screen_pos = Vec(pos.x + i - 1, pos.y):toscreen(settings)
        local quad = self.QUADS[c]
        if quad == nil then
            error("No font specified for character '" .. tostring(c) .. "'")
        end
        love.graphics.draw(
            self.sprite, quad,
            screen_pos.x, screen_pos.y, 0,
            SCALE.x, SCALE.y
        )
    end
end

return M

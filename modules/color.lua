local M = {}

local function hex(val)
    return {love.math.colorFromBytes(
        bit.rshift(bit.band(val, 0xff0000), 16),
        bit.rshift(bit.band(val, 0x00ff00), 8),
        bit.band(val, 0x0000ff)
    ),}
end

M.fromHex = hex
M.WHITE = hex(0xffffff)
M.BLACK = hex(0x000000)

M.RED = hex(0xff0000)
M.GREEN = hex(0x00ff00)
M.BLUE = hex(0x0000ff)

M.YELLOW = hex(0xffff00)
M.CYAN = hex(0x00ffff)
M.MAGENTA = hex(0xff00ff)

M.ORANGE = hex(0xff8800)
inspect{M.ORANGE}

return M

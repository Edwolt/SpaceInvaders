local M = {}
M.__index = M

----- Constructors -----
local function new(_, x, y)
    local self = {x = x, y = y}
    assert(type(self.x) == 'number')
    assert(type(self.y) == 'number')

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

function M.windowSize()
    return M(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )
end

function M.imageSize(sprite)
    return M(
        sprite:getWidth(),
        sprite:getHeight()
    )
end

----- Methods -----
function M:clone()
    return M(self.x, self.y)
end

function M:norm()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function M:dot(b)
    local a = self
    return a.x * b.x + a.y * b.y
end

function M:cross(b)
    local a = self
    return a.x * b.y - a.y * b.x
end

function M:versor()
    -- if self == (0, 0), thre's no versor
    if self:norm() == 0 then
        return M(0, 0)
    end

    -- return self / ||self||
    return self / self:norm()
end

function M.__add(a, b)
    if type(a) == 'table' and type(b) == 'table' then
        return M(
            a.x + b.x,
            a.y + b.y
        )
    elseif (type(a) == 'table' and type(b) == 'number')
        or (type(a) == 'number' and type(b) == 'table') then
        --
        if (type(a) == 'number') then
            a, b = b, a
        end
        return M(
            a.x + b,
            a.y + b
        )
    else
        error(string.format('invalid types %s + %s', type(a), type(b)))
    end
end

function M.__sub(a, b)
    if type(a) == 'table' and type(b) == 'table' then
        return M(
            a.x - b.x,
            a.y - b.y
        )
    elseif (type(a) == 'table' and type(b) == 'number')
        or (type(a) == 'number' and type(b) == 'table') then
        --
        if (type(a) == 'number') then
            a, b = b, a
        end
        return M(
            a.x - b,
            a.y - b
        )
    else
        error(string.format('invalid types %s - %s', type(a), type(b)))
    end
end

function M.__unm(a)
    return M( -a.x, -a.y)
end

function M.__mul(a, b)
    if type(a) == 'table' and type(b) == 'table' then
        return M(
            a.x * b.x,
            a.y * b.y
        )
    elseif (type(a) == 'table' and type(b) == 'number')
        or (type(a) == 'number' and type(b) == 'table') then
        --
        if (type(a) == 'number') then
            a, b = b, a
        end
        return M(
            a.x * b,
            a.y * b
        )
    else
        error(string.format('invalid types %s * %s', type(a), type(b)))
    end
end

function M.__div(a, b)
    if type(a) == 'table' and type(b) == 'table' then
        return M(
            a.x / b.x,
            a.y / b.y
        )
    elseif type(a) == 'table' and type(b) == 'number' then
        return M(
            a.x / b,
            a.y / b
        )
    else
        error(string.format('invalid types %s / %s', type(a), type(b)))
    end
end

function M.__tostring(vec)
    return string.format('(x=%d, y=%d)', vec.x, vec.y)
end

----- Misc Methods -----
function M:toscreen()
    local SCALE = SETTINGS.SCALE()
    local BLOCK_SIZE = SETTINGS.BLOCK_SIZE
    return SCALE * BLOCK_SIZE * self
end

return M

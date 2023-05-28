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

--- Returns Vec with the size of the windows as the components
function M.windowSize()
    return M(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )
end

--- Returns Vec with the size of the image sprite as the components
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

--- v.norm returns ||v||
function M:norm()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

--- v.dot(u) returns the dot product of v and u
function M:dot(b)
    local a = self
    return a.x * b.x + a.y * b.y
end

--- v.dot(u) returns the cross product of v and u
function M:cross(b)
    local a = self
    return a.x * b.y - a.y * b.x
end

--- u = v.versor() will make u have the same direction of v, but ||u|| = 1
--- unless, v is (0, 0), then u will also be (0, 0)
function M:versor()
    -- if self == (0, 0), thre's no versor
    if self:norm() == 0 then
        return M(0, 0)
    end

    -- return self / ||self||
    return self / self:norm()
end

------ Operators ------
--- Operators will be broadcasted
--- that's mean, for example, that u * v isn't cross or dot product
--- But a vector with (u.x * v.x, u.y, v.y)

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
--- Scale vector to the size of the screen
function M:toscreen()
    local SCALE = SETTINGS.SCALE()
    local BLOCK_SIZE = SETTINGS.BLOCK_SIZE
    return SCALE * BLOCK_SIZE * self
end

return M

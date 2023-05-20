local inspect = require'modules.inspect'
local M = {}
M.__index = M

local function new(_, x, y)
    local self = {
        x = x or 0,
        y = y or 0,
    }
    assert(type(self.x) == 'number')
    assert(type(self.y) == 'number')
    return setmetatable(self, M)
end
setmetatable(M, {__call = new})


function M:copy()
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
        error('invalid types ' .. type(a) .. ' + ' .. type(b))
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
        error('invalid types ' .. type(a) .. ' - ' .. type(b))
    end
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
        error('invalid types ' .. type(a) .. ' * ' .. type(b))
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
        error('invalid types ' .. type(a) .. ' / ' .. type(b))
    end
end

function M.__tostring(vec)
    return '(' .. vec.x .. ', ' .. vec.y .. ')'
end

return M

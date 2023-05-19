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

function M:versor()
    -- return self / ||self||
    return self / self:norm()
end

function M.__add(vec1, vec2)
    assert(
        type(vec1) == 'table' and type(vec2) == 'table',
        'invalid types ' .. type(vec1) .. ' + ' .. type(vec2)
    )

    return M(
        vec1.x + vec2.x,
        vec1.y + vec2.y
    )
end

function M.__sub(vec1, vec2)
    assert(
        type(vec1) == 'table' and type(vec2) == 'table',
        'invalid types ' .. type(vec1) .. ' - ' .. type(vec2)
    )

    return M(
        vec1.x - vec2.x,
        vec1.y - vec2.y
    )
end

function M.__mul(vec, num)
    assert(
        (type(vec) == 'table' and type(num) == 'number') or
        (type(vec) == 'number' and type(num) == 'table'),
        'invalid types ' .. type(vec) .. ' * ' .. type(num)
    )

    if type(vec) == 'number' then
        vec, num = num, vec
    end

    return M(
        vec.x * num,
        vec.y * num
    )
end

function M.__div(vec, num)
    assert(
        (type(vec) == 'table' and type(num) == 'number') or
        (type(vec) == 'number' and type(num) == 'table'),
        'invalid types ' .. type(vec) .. ' / ' .. type(num)
    )

    if type(vec) == 'number' then
        vec, num = num, vec
    end

    return M(
        vec.x / num,
        vec.y / num
    )
end

function M.__tostring(vec)
    return '(' .. vec.x .. ', ' .. vec.y .. ')'
end

return M

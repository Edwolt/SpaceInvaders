local M = {}
M.__index = M

function M:new(x, y)
    local vec = {
        x = x or 0,
        y = y or 0,
    }
    setmetatable(vec, self)

    function vec:copy()
        return M:new(vec.x, vec.y)
    end

    function vec:norm()
        return math.sqrt(self.x * self.x + self.y * self.y)
    end

    function vec:versor()
        -- return self / ||self||
        return M:new(self.div(self.norm()))
    end

    return vec
end

-- Operator Overloading
function M.__add(vec1, vec2)
    return M:new(
        vec1.x + vec2.x,
        vec1.y + vec2.y
    )
end

function M.__sub(vec1, vec2)
    return M:new(
        vec1.x - vec2.x,
        vec1.y - vec2.y
    )
end

function M.__mul(vec, num)
    if getmetatable(num) == M then
        vec, num = num, vec
    end

    return M:new(
        vec.x * num,
        vec.y * num
    )
end

function M.__div(vec, num)
    if getmetatable(num) == M then
        vec, num = num, vec
    end

    return M:new(
        vec.x / num,
        vec.y / num
    )
end

function M.__tostring(vec)
    return '(' .. vec.x .. ',' .. vec.y .. ')'
end

return M

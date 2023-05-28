return function(qtt, size)
    local sprite_size = qtt * size
    local res = {}

    for i = 0, qtt - 1 do
        res[#res + 1] = love.graphics.newQuad(
            size.x * i, 0,
            size.x, size.y,
            sprite_size.x, size.y
        )
    end
    return res
end

return function(t)
    local clone = {}
    for k, i in pairs(t) do
        clone[k] = i
    end

    setmetatable(clone, getmetatable(t))
    return clone
end

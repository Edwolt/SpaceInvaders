return function(opts)
    local value = opts[1]
    local name = opts[2] and opts[2] .. ' = ' or ''
    local show_meta = opts.meta or false

    if type(value) == 'table' then
        print(name .. '{')

        for ki, i in pairs(value) do
            print(string.format('  %s = %s', tostring(ki), tostring(i)))
        end

        if show_meta then
            local meta = getmetatable(value)
            for ki, i in pairs(meta) do
                print(' $%s = %s', tostring(ki), tostring(i))
            end
        end

        print'}'
    else
        print(name .. tostring(value))
    end
end

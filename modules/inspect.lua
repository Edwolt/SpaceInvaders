function f(opts, n)
    if type(opts) ~= 'table' then
        f{opts, n}
    end

    local value = opts[1]
    local name = opts[2] and opts[2] .. ' = ' or ''
    local show_meta = opts.meta or false

    if type(value) == 'table' then
        print(name .. '{')

        for ki, i in ipairs(value) do
            print('   #' .. tostring(ki) .. ' = ' .. tostring(i))
        end
        for ki, i in pairs(value) do
            print('    ' .. tostring(ki) .. ' = ' .. tostring(i))
        end

        if show_meta then
            local meta = getmetatable(value)
            for ki, i in ipairs(meta) do
                print('  $#' .. tostring(ki) .. ' = ' .. tostring(i))
            end
            for ki, i in pairs(meta) do
                print('  $ ' .. tostring(ki) .. ' = ' .. tostring(i))
            end
        end

        print'}'
    else
        print(name .. tostring(value))
    end
end

return f

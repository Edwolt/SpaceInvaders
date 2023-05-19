return function(value, name, show_meta)
    name = name and name .. ' = ' or ''
    if value == nil then
        print(name .. 'nil')
    elseif type(value) == 'number' then
        print(name .. value)
    elseif type(value) == 'string' then
        print(name .. '"' .. value .. '"')
    elseif type(value) == 'table' then
        show_meta = show_meta or false
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
        print(name .. '???')
    end
end

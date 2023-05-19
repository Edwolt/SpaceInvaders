return function(table)
    for ki, i in ipairs(table) do
        print('#', ki, '=', i)
    end
    for ki, i in pairs(table) do
        print('>', ki, '=', i)
    end
end

return {
    print = print,
    log = {
        load = function(name)
            print(string.format('> Loading %s ...', name))
        end,

        loaded = function(name)
            print('> Loaded ' .. name)
        end,

        loadedv = function(name, value)
            print(string.format('> Loaded %s = %s', name, tostring(value)))
        end,

        save = function(name, value)
            print(string.format('> Saving %s = %s', name, tostring(value)))
        end,

        saved = function(name)
            print(string.format('> Saved %s', name))
        end,
    },
    inspect = function(opts)
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
    end,
}

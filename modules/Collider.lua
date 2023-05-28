local Vec = require'modules.Vec'

local M = {}
M.__index = M

local function new(_, pos, size)
    local self = {
        pos = pos,
        size = size,
    }

    setmetatable(self, M)
    return self
end
setmetatable(M, {__call = new})

--- Checks is a collision happened
function M.collision(a, b)
    local a1, a2 = a.pos, a.pos + a.size
    local b1, b2 = b.pos, b.pos + b.size

    local on_x = a1.x < b2.x and a2.x > b1.x
    local on_y = a1.y < b2.y and a2.y > b1.y
    return on_x and on_y
end

function M:draw(color)
    love.graphics.setColor(color)

    local screen_pos = self.pos:toscreen()
    local screen_size = self.size:toscreen()

    love.graphics.rectangle(
        'line',
        screen_pos.x, screen_pos.y,
        screen_size.x, screen_size.y
    )
end

--- Check collision of all against all of list
--- list must be a list of Colliders
---
--- This function will iterate over the list checking if there are 
--- collision between its elements
--- 
--- For every collision,
--- f will be executed with the indices of the collisors as parameters 
---
--- If f returns break the iteration stops
--- If f returns continue, look at the implementation to see what happens
function M.checkCollisionsNtoN(list, f, ...)
    for i = 1, #list do
        for j = i + 1, #list do
            if list[i]:collision(list[j]) then
                local res = f(i, j, ...)
                if res == 'break' then
                    return
                elseif res == 'continue' then
                    break
                end
            end
        end
    end
end

--- Check collision of list1 against list2
--- list1 and list2 must be a list of Colliders
---
--- This function will iterate over the lists checking if there are 
--- collisions between colliders of list1 and colliders of list2
--- 
--- For every collision,
--- f will be executed with the indices of the collisors as parameters 
---
--- If f returns break the iteration stops
--- If f returns continue the iteration will stop checking collision with the
--- current item of the list1
function M.checkCollisionsNtoM(list1, list2, f, ...)
    for i = 1, #list1 do
        for j = 1, #list2 do
            if list1[i]:collision(list2[j]) then
                local res = f(i, j, ...)
                if res == 'break' then
                    return
                elseif res == 'continue' then
                    break
                end
            end
        end
    end
end

--- Get the screen collider
--- (Testing collision with a object tells if it's on screen)
function M.screenCollider()
    local SCREEN_BLOCKS = SETTINGS.SCREEN_BLOCKS
    return M(Vec(0, 0), SCREEN_BLOCKS)
end

return M

local M = M or {
    paused = false;
}

function M:pause(val)
    if val == nil then
        M.paused = not M.paused;
    else
        M.pause =  val
    end
end

function M:update(dt)
    if self.paused then
        print('paused')
        return
    end
end

return M

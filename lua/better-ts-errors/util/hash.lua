local M = {}

M.simpleHash = function(input)
    local hash = 0
    for i = 1, #input do
        local char = string.byte(input, i)
        hash = (hash * 31 + char) % 2 ^ 32
    end
    return hash
end

return M

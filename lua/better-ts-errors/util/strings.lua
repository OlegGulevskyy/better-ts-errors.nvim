local M = {}

M.break_new_lines = function(message)
    local body_lines = {}
    for line in vim.gsplit(message, "\n") do
        table.insert(body_lines, line)
    end
    return body_lines
end

M.trim_string = function(str)
    return string.match(str, "%s*(.-)%s*$")
end


-- Utility to calculate left pad for a given string
-- This should help us calculate the identation for a line of message
M.get_padding = function(str)
    local whitespaces = string.match(str, "^%s*")
    return #whitespaces
end

return M

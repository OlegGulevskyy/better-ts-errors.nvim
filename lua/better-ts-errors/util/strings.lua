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

return M
